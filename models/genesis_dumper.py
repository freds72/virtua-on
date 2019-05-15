import sys, pygame
import os
import re
import tempfile
import random
import math
import struct

size = width, height = 512, 512
scale = 1
    
pygame.init()
pygame.key.set_repeat(125)

local_dir = os.path.dirname(os.path.realpath(__file__))
my_font = pygame.font.SysFont("Courier", 16)
mem_offset = 0x00138200 # Track 1 (Genesis)
# mem_offset = 0x0014c200 # Track 2 (Genesis)
# mem_offset = 0x00164290 # Track 2 (Genesis)
# mem_offset = 0x0014c200
# mem_offset = 0x00108000
# mem_offset = 0xa000 # start of poly data (32x)
frame = 0
point_sel = 0
ob_offset = 0
tmp_offset = 0

def project(x,y,z):
    return (256+scale*x/512,256-scale*z/512)
    angle = frame/2048
    xx = x #*math.cos(angle) - z*math.sin(angle)
    zz = z #*math.cos(angle) + x*math.sin(angle)
    zz /= 4096
    zz += 16*scale
    if zz>0:
        y -= 4096
        return (256+xx/zz, 256-y/zz)
    return (256+width*x/2048, 256-height*y/2048)

with open(os.path.join(local_dir,"Virtua Racing (USA).md"), 'rb') as rom_file:
    
    screen = pygame.display.set_mode(size)
    run = True
    while run:
        for ev in pygame.event.get():
            if ev.type == pygame.QUIT:
                run = False
                break

            if ev.type == pygame.KEYDOWN:
                if ev.key == pygame.K_LEFT: mem_offset -= 1
                if ev.key == pygame.K_RIGHT: mem_offset += 1
                if ev.key == pygame.K_UP: scale += 1
                if ev.key == pygame.K_DOWN: scale -= 1
                if ev.key == pygame.K_PAGEUP: ob_offset += tmp_offset
                if ev.key == pygame.K_PAGEDOWN: ob_offset = 0
                if ev.key == pygame.K_b: point_sel -= 1
                if ev.key == pygame.K_n: point_sel += 1
                mem_offset = max(0,mem_offset)
                mem_offset = min(0x001ffff0, mem_offset)

                scale = max(1,scale)
                point_sel = max(0,point_sel)

        # draw        
        screen.fill((0,0,0))
        the_text = my_font.render("Offset: 0x{:08x}".format(mem_offset + ob_offset), True, (255,255,255))
        screen.blit(the_text, (10, 10))

        rom_file.seek(mem_offset + ob_offset)
        for o in range(128):
            # format: http://forums.sonicretro.org/index.php?showtopic=38296
            unknown_flag = rom_file.read(1)
            # number of faces
            faces_count = rom_file.read(1)[0]+1
            tmp_offset = 2
            point_i = 0
            if faces_count<500000:
                for i in range(faces_count):
                    # face flags
                    face_colors = rom_file.read(1)
                    face_flags = rom_file.read(1)
                    tmp_offset += 2

                    vertex_count = 3 if (0x10 & face_flags[0]) == 0x10 else 4
                    points = []
                    for k in range(vertex_count):
                        x = int.from_bytes(rom_file.read(2), byteorder='big', signed=True)
                        y = int.from_bytes(rom_file.read(2), byteorder='big', signed=True)
                        z = int.from_bytes(rom_file.read(2), byteorder='big', signed=True)
                        tmp_offset += 6

                        point = project(x,y,z)
                        points.append(point)
                    try:
                        if point_i == point_sel:
                            # the_text = my_font.render("Point: 0x{:04x} 0x{:04x} 0x{:04x}".format(x,y,z), True, (255,255,255))
                            the_text = my_font.render("Colors: 0x{:02x} Flags: 0x{:02x}".format(face_colors[0],face_flags[0]), True, (255,255,255))
                            screen.blit(the_text, (10, 24))        
                            pygame.draw.lines(screen, (255,0,0), True, points)
                        else:
                            pygame.draw.lines(screen, (255,255,255), True, points)
                    except:
                        pass
                    point_i += 1
                    
            the_text = my_font.render("Face count: {}".format(faces_count), True, (255,255,255))
            screen.blit(the_text, (10, 36))

            the_text = my_font.render("End: 0x{:08x}".format(mem_offset + tmp_offset), True, (255,255,255))
            screen.blit(the_text, (10, 48))        

        pygame.display.flip()
        frame += 1

pygame.quit()

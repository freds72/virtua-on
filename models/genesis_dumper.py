import sys, pygame
import os
import re
import tempfile
import random
import math
import struct

size = width, height = 512, 512
scale = 130
    
pygame.init()
pygame.key.set_repeat(125)

local_dir = os.path.dirname(os.path.realpath(__file__))
my_font = pygame.font.SysFont("Courier", 16)
# Genesis
mem_offset = 0x00138200 # Track 1
# mem_offset = 0x0014c200 # Track 2
# mem_offset = 0x00164298 # Track 3 - 167 segments
# mem_offset = 0x0014c200
# mem_offset = 0x00108000 # 0x0010c000 # car??
# mem_offset = 0x12bd7c  # rear tires
# mem_offset = 0x1291ee  # rear tires
# mem_offset = 0x122522  # rear tires
#mem_offset = 0x0010c000 # 

# mem_offset = 0x0109f2a # car body 2
# mem_offset = 0x010d930 # car body 2

# 32x
# mem_offset = 0xa000 # start of poly data
frame = 0
face_count_override = 0
ob_offset = 0
tmp_offset = 0
flag_mask = 1

def project(x,y,z):
    #return (256+scale*x/512,256-scale*z/512)
    angle = frame/2048
    x /= 256
    y /= 256
    z /= 256
    z -= 5
    xx = x*math.cos(angle) - y*math.sin(angle)
    zz = y*math.cos(angle) + x*math.sin(angle)
    zz += scale
    if zz>0:
        return (256+16*xx/y, 256-16*zz/y)
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
                if ev.key == pygame.K_PAGEUP: mem_offset += 100 # ob_offset += tmp_offset
                if ev.key == pygame.K_PAGEDOWN: mem_offset -= 100  # ob_offset = 0
                if ev.key == pygame.K_b: face_count_override -= 1
                if ev.key == pygame.K_n: face_count_override += 1
                if ev.key == pygame.K_f: flag_mask = flag_mask<<1
                mem_offset = max(0,mem_offset)
                mem_offset = min(0x001ffff0, mem_offset)
                
                # scale = max(1,scale)
                face_count_override = max(0,face_count_override)
                if flag_mask>0xf:
                    flag_mask=1

        # draw        
        screen.fill((0,0,0))
        the_text = my_font.render("Offset: 0x{:08x}".format(mem_offset + ob_offset), True, (255,255,255))
        screen.blit(the_text, (10, 10))

        rom_file.seek(mem_offset + ob_offset)
        total_faces = 0
        for o in range(130):
            # format: http://forums.sonicretro.org/index.php?showtopic=38296
            unknown_flag = rom_file.read(1)
            # number of faces
            faces_count = rom_file.read(1)[0]+1   
            total_faces += faces_count  
            tmp_offset = 2
            if faces_count<255:                
                for i in range(faces_count):
                    face_colors = rom_file.read(1)[0]
                    # face flags
                    # 0x8: n/a
                    # 0x4: track
                    # 0x2: grass/dirt???
                    # 0x1: non-track (inc. markings)
                    # 0x0: ??
                    face_flags = rom_file.read(1)[0]
                    tmp_offset += 2

                    vertex_count = 3 if (0x10 & face_flags) == 0x10 else 4
                    c = face_colors #*(1 if face_flags & flag_mask else 0)
                    points = []
                    for k in range(vertex_count):
                        x = int.from_bytes(rom_file.read(2), byteorder='big', signed=True)
                        y = int.from_bytes(rom_file.read(2), byteorder='big', signed=True)
                        z = int.from_bytes(rom_file.read(2), byteorder='big', signed=True)
                        tmp_offset += 6

                        point = project(x,y,z)
                        points.append(point)
                    try:                    
                        pygame.draw.lines(screen, (c,c,c), True, points)
                        
                    except:
                        raise
        the_text = my_font.render("Face count: {}".format(total_faces), True, (255,255,255))
        screen.blit(the_text, (10, 48))        

        the_text = my_font.render("Scale: {}".format(scale), True, (255,255,255))
        screen.blit(the_text, (10, 60))        

        pygame.display.flip()
        frame += 1

pygame.quit()

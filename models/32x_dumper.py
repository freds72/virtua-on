import sys, pygame
import os
import re
import tempfile
import random
import math
import struct

size = width, height = 512, 512
scale = 32
    
pygame.init()
pygame.key.set_repeat(125)

local_dir = os.path.dirname(os.path.realpath(__file__))
my_font = pygame.font.SysFont("Courier", 16)
mem_offset = 0x0108000
 # bridge/map
frame = 0
scan_length = 2048
point_sel = 0

def project(x,y,z):
    angle = frame/512
    xx = x*math.cos(angle) - z*math.sin(angle)
    zz = z*math.cos(angle) + x*math.sin(angle)
    y -= 512
    zz += 2048
    if zz!=0:
        return (256+scale*xx/zz, 256-scale*y/zz)
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
                if ev.key == pygame.K_LEFT: mem_offset -= 2
                if ev.key == pygame.K_RIGHT: mem_offset += 2
                if ev.key == pygame.K_UP: scale += 1
                if ev.key == pygame.K_DOWN: scale -= 1
                if ev.key == pygame.K_PAGEUP: mem_offset += 0x1000
                if ev.key == pygame.K_PAGEDOWN: mem_offset -= 0x1000
                if ev.key == pygame.K_HOME: scan_length -= 16
                if ev.key == pygame.K_END: scan_length += 16
                if ev.key == pygame.K_b: point_sel -= 1
                if ev.key == pygame.K_n: point_sel += 1

                mem_offset = max(0,mem_offset)
                mem_offset = min(0x002ffff0, mem_offset)

                scale = max(1,scale)
                scan_length = max(0,scan_length)
                point_sel = max(0,point_sel)

        # draw        
        screen.fill((0,0,0))
        the_text = my_font.render("Offset: 0x{:08x} Scan length: {}".format(mem_offset, scan_length), True, (255,255,255))
        screen.blit(the_text, (10, 10))

        rom_file.seek(mem_offset)
        point_i = 0
        for k in range(scan_length):
            bx = rom_file.read(2)
            by = rom_file.read(2)
            bz = rom_file.read(2)

            x = int.from_bytes(rom_file.read(2), byteorder='big', signed=True)
            y = int.from_bytes(rom_file.read(2), byteorder='big', signed=True)
            z = int.from_bytes(rom_file.read(2), byteorder='big', signed=True)

            point = project(x,y,z)
            try:
                if point_i == point_sel:
                    the_text = my_font.render("Point: 0x{} 0x{} 0x{}".format(bx.hex(),by.hex(),bz.hex()), True, (255,255,255))
                    screen.blit(the_text, (10, 24))        
                    pygame.draw.rect(screen, (255,0,0), (point[0]-1,point[1]-1,2,2))            
                else:
                    pygame.draw.rect(screen, (255,255,255), (point[0]-1,point[1]-1,2,2))            
            except:
                pass
            point_i += 1

        pygame.display.flip()
        frame += 1

pygame.quit()

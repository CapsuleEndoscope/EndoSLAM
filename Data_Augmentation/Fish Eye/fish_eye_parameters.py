import pygame
import math
import glob
import cv2
import argparse


argPar = argparse.ArgumentParser(description='fisheye modification')

argPar.add_argument("--INPUT_PATH",required=True,help="input data path")
argPar.add_argument("--INPUT_FILE",required=True,help="input file name")
argPar.add_argument("--OUTPUT_PATH",required=True,help="output path")
argPar.add_argument("--OUTPUT_FILE",required=True,help="output file name")
argPar.add_argument("--DISTORT_PARAM",required=True,help="radial distortion degree, param range between 0-1")

args = argPar.parse_args()
output_image_path = args.OUTPUT_PATH + args.OUTPUT_FILE
filename = args.INPUT_PATH + args.INPUT_FILE
fishEye_param = args.DISTORT_PARAM
print(filename)


def fish_eye(image: pygame.Surface,ratio):
    """ Fish eye algorithm ratio 0-1"""
    w, h = image.get_size()
    w2 = w / 2
    h2 = h / 2
    image_copy = pygame.Surface((w, h), flags=pygame.RLEACCEL).convert()
    for y in range(h):
        # Normalize every pixels along y axis
        # when y = 0 --> ny = -1
        # when y = h --> ny = +1
        ny = ((2 * y) / h) - 1
        # ny * ny pre calculated
        ny2 = ny ** 2
        for x in range(w):
            # Normalize every pixels along x axis
            # when x = 0 --> nx = -1
            # when x = w --> nx = +1
            nx = ((2 * x) / w) - 1
            # pre calculated nx * nx
            nx2 = nx ** 2

            # calculate distance from center (0, 0)
            r = math.sqrt(nx2 + ny2)

            # discard pixel if r below 0.0 or above 1.0
            if 0.0 <= r <= 1.0:

                nr = ratio * (r + 1 - math.sqrt(1 - r ** 2)) / 2
                if nr <= 1.0:

                    theta = math.atan2(ny, nx)
                    nxn = nr * math.cos(theta)
                    nyn = nr * math.sin(theta)
                    x2 = int(nxn * w2 + w2)
                    y2 = int(nyn * h2 + h2)

                    if 0 <= int(y2 * w + x2) < w * h:

                        pixel = image.get_at((x2, y2))
                        image_copy.set_at((x, y), pixel)

    return image_copy


if __name__ == '__main__':
	w, h = 480, 480

	black_im_path = r".\black480.png"

	frame_cntr = 0

	for i in sorted(glob.glob(input_image_path)):
                print(i)
                screen = pygame.display.set_mode((w , h)) 
                background = pygame.image.load(black_im_path).convert()
                background.set_alpha(None)
                surface32 = pygame.image.load(i).convert_alpha()
                surface32 = pygame.transform.smoothscale(surface32, (w, h))	        
                screen.fill((0, 0, 0))
                screen.blit(background, (0, 0))
                screen.blit(fish_eye(surface32,fishEye_param ), (0, 0))		
                pygame.image.save(screen, output_image_path+ "\\"+str(frame_cntr) + '.png')
                frame_cntr += 1

import cv2
import sys
import numpy as np

_, in_file, out_file = sys.argv

WIDTH = 320
HEIGHT = 240

img = cv2.imread(in_file)
img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
img_resized = cv2.resize(img, (WIDTH, HEIGHT))

img_resized &= np.uint8(0xF0)

with open(out_file, 'w') as file:
    #file.write(f'{WIDTH} {HEIGHT}\n')

    for col in img_resized:
        for pixel in col:
            pixel_data = (pixel[0]>>4) << 8 | (pixel[1]>>4)<<4 | pixel[2]>>4
            file.write(f'{pixel_data}\n')
            #print(pixel, hex(pixel_data))

cv2.imwrite('out.png', img_resized)
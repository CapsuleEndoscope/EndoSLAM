import glob
import argparse
import os
import shutil

argPar = argparse.ArgumentParser(description='frame per secodn modifier')

argPar.add_argument("--INPUT_PATH",required=True,help="input data path")
argPar.add_argument("--OUTPUT_PATH",required=True,help="output path")
argPar.add_argument("--FPS",required=True,help="required frame per second less than 20fps")

args = argPar.parse_args()
input_path = args.INPUT_PATH
output_path = args.OUTPUT_PATH
fps = args.FPS

frame_cntr = 1

for frame in sorted(glob.glob(input_path)):   
    #if (frame_cntr % fps == 0) :
       #shutil.copy(frame,destination_folder+frame.split("\")[-1])        
    if (frame_cntr % fps != 0) : 
       os.remove(frame)  
       print(frame_cntr)
    frame_cntr += 1

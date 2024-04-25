import os
import sys
import struct

if len(sys.argv) < 2:
    print("Usage: python script_name.py inp_file")
    sys.exit(1)

inp_file = sys.argv[1]
#print("Input file:", inp_file)

out_dir  = '../1.gowin/src'
out_file = os.path.join(out_dir, 'imem.INIT.vh')
out_dmem = os.path.join(out_dir, 'dmem.INIT.vh')

imem_text = ''

dmem_text = ''

#print(f"Bin file size: {len(bin_contents)} bytes")

def extract_mem_bytes(file_path):
    addr = 0
    imem_values = []
    dmem_values = []
    isImem = 0
    with open(file_path, 'r') as file:
        for line in file:
            #print("Processing line:", line) 
            if line.startswith('@'):
                isImem += 1
                continue # Stop reading after the second @ row
            # DMEM bytes
            hex_temp = line.strip().split()
            if(isImem == 2):
                for i in range(0, len(hex_temp), 4):
                    if(i + 4 > len(hex_temp)):
                        hex_sublist = hex_temp[i:i+len(hex_temp)]
                    else:
                        hex_sublist = hex_temp[i:i+4]
                    hex_sublist.reverse()
                    dmem_values.extend(hex_sublist)
            else :
            # IMEM bytes
                for i in range(0, len(hex_temp), 4):
                    hex_sublist = hex_temp[i:i+4]
                    hex_sublist.reverse()
                    imem_values.extend(hex_sublist)

    return imem_values, dmem_values
file_path = sys.argv[1]
imem_values, dmem_values = extract_mem_bytes(file_path)

addr = 0
# Writing to files
try: 
    with open(out_file, 'w') as imem_SW_file:

        for i in range(0, len(imem_values), 4):
            value = imem_values[i] + imem_values[i+1] + imem_values[i+2] + imem_values[i+3]
            imem_text += f"mem[\'h{addr:04X}] = 32\'h{value};\n"
            addr += 1
    
        imem_SW_file.write(imem_text)
except Exception as e:
    print(f"Write file Exception: {e}")
    sys.exit(-1)

addr = 0
try: 
    with open(out_dmem, 'w') as dmem_SW_file:

        for i in range(0, len(dmem_values), 4):
            value = ''
            if(i + 4 > len(dmem_values)):
                for j in range(i, len(dmem_values)):
                    value += dmem_values[j]
                for k in range(len(dmem_values), i + 4):
                    value += '00'
            else:
                value = dmem_values[i] + dmem_values[i+1] + dmem_values[i+2] + dmem_values[i+3]
            dmem_text += f"mem_ary[\'h{addr:04X}] = 32\'h{value};\n"
            addr += 1
    
        dmem_SW_file.write(dmem_text)
except Exception as e:
    print(f"Write file Exception: {e}")
    sys.exit(-1)
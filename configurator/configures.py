#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Created on Sat Apr 15 15:11:30 2023

@author: ellenfel

"""
import os
import re
import yaml
import pandas

FILENAME = "tb_gateway.yaml"

start_dir = os.getcwd()

print(start_dir)
#input()

os.chdir('/etc/thingsboard-gateway/config/')
workin_dir = os.getcwd()
print("working dir = " + workin_dir)
#input()

with open(FILENAME, "r") as stream:
    try:
        configParse =yaml.safe_load(stream)
    except yaml.YAMLError as exc:
        print(exc)
        
def extractingParameters(str):
    

    port = configParse.get("thingsboard").get("port")
    remoteConfiguration = configParse.get("thingsboard").get("remoteConfiguration")
    remoteShell = configParse.get("thingsboard").get("remoteShell")
    AT = configParse.get("thingsboard").get("security").get("accessToken")
    host = configParse.get("thingsboard").get("host")

    #parameters that we are interested to configure
    data = [ ['port',port], ['remoteConfiguration',remoteConfiguration], 
            ['remoteShell',remoteShell], ['AT',AT], ['host',host] ]

    df = pandas.DataFrame(data, columns=['Name','Configuration'])

    return df
"""
#Parsing Sub-dirs 
Parse_connectors = configParse.get("connectors")
Parse_thingsboard = configParse.get("thingsboard")
Parse_grpc = configParse.get("grpc")
Parse_storage = configParse.get("storage")
"""

df = extractingParameters(FILENAME)
print(df)


#this function gets dict as input to configure the port
def editPort(dict):
    
    currentPort = configParse['thingsboard']["port"]
    
    try:
        newPort = int(input("Current port : {}\nwill reconfigure Port to entered value "
                            .format(currentPort)))
        
    except ValueError:
        print("Enter a valid value for the port")
    
    else:
        print("reconfiguring the port to ",newPort)
    
    configParse['thingsboard']["port"] = newPort
    return configParse


def accsessToken(dict):
    
    currentAccsessToken = configParse['thingsboard']["security"]["accessToken"]
    
    try:
        newAccsessToken = input("Enter Access Token :")
        
    except ValueError:
        print("Enter a valid value for the Token")
    
    else:
        print("reconfiguring the Gateway with token :",currentAccsessToken)
    
    configParse['thingsboard']["security"]["accessToken"] = newAccsessToken
    return configParse



editPort(configParse)
accsessToken(configParse)


os.chdir('/home/ellenfel/Desktop/repos/IoT-Hub-Configurator/')
workin_dir = os.getcwd()
print("working dir = " + workin_dir)
input()

file=open("new_config.yaml","w")
yaml.dump(configParse,file)
file.close()
print("YAML file saved.")


def startService():
    try:
        #start apache2 service
        os.popen("sudo systemctl restart thingsboard-gateway.service")
        print("IoT-Gateway service started successfully...")
        
    except OSError as ose:
        print("Error while running the command", ose)
   
    pass

startService()

"""
import re

def find_config_numbers(lines):

    pattern = r"^\s*config.*'(\d+)'\s*$"
    config_numbers = []
    for line in lines:
        match = re.match(pattern, line)
        if match:
            config_numbers.append(match.group(1))
    return config_numbers

# Read in the entire text file as a single string
with open("file.txt", "r") as f:
    text = f.read()

# Split the text into a list of lines
lines = text.splitlines()


# Ask the user how many times they want to paste the text
n_pastes = int(input("How many times do you want to paste the text? "))

# Find the line numbers that contain the pattern "config 'number'"
config_numbers = find_config_numbers(lines)

# Loop through the desired number of pastes
for i in range(n_pastes):

    # Initialize a new list to store the modified lines
    modified_lines = []

    # Loop through each line of the original text
    j = 0
    while j < len(lines):
        line = lines[j]


        if line.startswith("config rtu_device") and i !=0:
            # Skip the current and next 11 lines
            j += 12
            continue
        
#        elif line.startswith("        option name 'T"):
#            pass

        # Check if the current line contains the pattern "config 'number'"
        if j in config_numbers:
            modified_lines.append(line)

        else:
            # Append the modified or unmodified line to the new list
            modified_lines.append(line)
            
        j += 1

    # Join the modified list of lines back into a single string
    modified_text = "\n".join(modified_lines)

    # Write the modified text to a file
    with open("output.txt", "a") as f:
        f.write(modified_text)
        f.write("\n")  # Add a newline character at the end of the file        
  



# Read in the entire text file as a single string
with open("output.txt", "r") as f:
    text_output = f.read()

# Split the text into a list of lines
lines_output = text_output.splitlines()

#config_numbers_output = find_config_numbers(lines_output)

def find_config_numbers_o(lines, x, slave_id):

    pattern1 = r"^\s*config rtu_device.*'(\d+)'\s*$"
    pattern2 = r"^\s*config rtu_slave.*'(\d+)'\s*$"
    pattern3 = r"^\s*config request_(\d+) '(\d+)'\s*$"
    pattern4 = r"^\s*option slave_id.*'(\d+)'\s*$"

    with open("output.txt", "r") as f, open("temp.txt", "w") as f_out:
        for line in f:
            match1 = re.match(pattern1, line)
            match2 = re.match(pattern2, line)
            match3 = re.match(pattern3, line)
            match4 = re.match(pattern4, line)
            
            if match1:
                # Replace the number in the detected pattern with x
                #modified_line = str(f"config rtu_device '{x}'\n")
                f_out.write(f"config rtu_device '{x}'\n")
                x+=1
                #print("match1! %d",x)
                
            elif match2:
                # Replace the number in the detected pattern with x
                #modified_line = str(f"config rtu_slave '{x}'\n")
                f_out.write(f"config rtu_slave '{x}'\n")
                z=x
                x+=1
                #print("match2! %d",x)
                print(line)
                
            elif match3:
                # Replace the number in the detected pattern with x
                #modified_line = str(f"config rtu_slave '{x}'\n")
                f_out.write(f"config request_{z} '{x}'\n")
                x+=1
                #print("match3! %d",x)
                
            elif match4:
                # Replace the number in the detected pattern with x
                #modified_line = str(f"config rtu_slave '{x}'\n")
                f_out.write(f"        option slave_id '{slave_id}'\n")
                slave_id+=1
                #print("match4! %d",x)
                
                
            else:
                f_out.write(line)  # Write the unmodified line to the output file
                

    # Replace the original file with the modified file
    # with open("temp.txt", "r") as f_in, open("file.txt", "w") as f_out:
    #     for line in f_in:
    #         f_out.write(line)
    return x


find_config_numbers_o(lines_output,2,50)







#working on changing the names from import file
import pandas as pd
df = pd.read_csv('EA_names.csv')

for i in range(14):
    print(df['names'][i])
"""

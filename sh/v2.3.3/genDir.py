'''
Created on Nov 12, 2014

@author: apuser
'''
import os
import datetime
import sys

files=""
def list_dir(path, res,level):  
    ''''' 
        res = {'dir':'root', 'child_dirs' : [] , 'files' : [],'level':0} 
        print list_dir('/root', res) 
    '''
    global files
    level+=1
    for i in os.listdir(path):  
        temp_dir = os.path.join(path,i)  
        if os.path.isdir(temp_dir):  
            temp = {'dir':temp_dir, 'child_dirs' : [] , 'files' : [],'level':level}
            #print temp_dir
            res['child_dirs'].append(list_dir(temp_dir, temp,level))  
        else:
            timestamp=os.path.getmtime(temp_dir)
            date = datetime.datetime.fromtimestamp(timestamp)
            #print temp_dir,os.path.getsize(temp_dir),date.strftime('%Y-%m-%d %H:%M:%S')
            files+=temp_dir+"  "+str(os.path.getsize(temp_dir))+"byte  "+ str(date.strftime('%Y-%m-%d %H:%M:%S')) + "\n"
            res['files'].append(i)
    return res  
  
def get_config_dirs(dir):  
    res = {'dir':'root', 'child_dirs' : [] , 'files' : [],'level':0}  
    return list_dir(dir,res,0)

if __name__ == '__main__':
    basepath="/home/apuser/common/wiki/v2.3.1/logs/slog_20141107142021_sp7731gea_user"
    #par=os.path.split(dir)[0]
    #sub=os.path.split(dir)[1]
    if len(sys.argv)>2:
        print "more than one args exist"
        sys.exit()
        pass
        basepath=""
    if len(sys.argv)==2:
        basepath=sys.argv[1]
    if not os.path.isdir(basepath):
        print "folder ",str(basepath)," is not exist"
        sys.exit()
    dirf=basepath+"_dir.txt"
    res= get_config_dirs(basepath)
    f = open(dirf,'w')
    f.write(files)
    f.close()
    if files != "":
        print "file store " + dirf
    else:
        print "no file found"
    pass
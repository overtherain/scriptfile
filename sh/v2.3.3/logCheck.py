# -*- coding: utf-8 -*-
'''
Created on Jun 27, 2014

@author: gary.gong
'''
import os
import sys
import getopt
from fileItem import FileItem
from folderParser import FolderParser
from configParser import ConfigParser
import platform
from os.path import join, getsize

def getdirsize(dir):
    size = 0L
    for root, dirs, files in os.walk(dir):
        size += sum([getsize(join(root, name)) for name in files])
    return size

def isLinux():
    sysstr = platform.system()
    if(sysstr == "Windows"):
        return False
    elif(sysstr == "Linux"):
        return True
    else:
        return False

class LogCheck(object):
    '''
    classdocs
    '''


    def __init__(self,basepath,confile="configs/config.xml"):
        '''
        Constructor
        '''
        self.basepath=basepath
        self.cp = ConfigParser(confile)
        self.fp=FolderParser(basepath)
        self.fileitems=self.cp.getCheckItems()
        if self.basepath==None or self.basepath=="":
            self.basepath=self.fp.getLogPath()
        #print "base path is " + self.basepath
        self.internal_bt_p2=0
        self.external_bt_p2=0
        pass
    
    def checkFile(self,f):
        if f == None:
            return False
        else:
            if isLinux():
                if f.find("/")==0:
		            pass
                else:
                    f="/"+f
                if self.basepath[len(self.basepath)-2:len(self.basepath)-1]=="/":
                    f=self.basepath[0:len(self.basepath)-2]+f
                else:
                    f=self.basepath+f
            else:
                if f.find("\\")==0:
                    pass
                else:
                    f="\\"+f
                if self.basepath[len(self.basepath)-2:len(self.basepath)-1]=="\\":
                    f=self.basepath[0:len(self.basepath)-2]+f
                else:
                    f=self.basepath+f
            #print "check file path is " + f
            if os.path.isfile(f):
                return True

    def getRealPath(self,f):
        if isLinux():
            if f.find("/")==0:
	            pass
            else:
                f="/"+f
            if self.basepath[len(self.basepath)-2:len(self.basepath)-1]=="/":
                f=self.basepath[0:len(self.basepath)-2]+f
            else:
                f=self.basepath+f
        else:
            if f.find("\\")==0:
                pass
            else:
                f="\\"+f
            if self.basepath[len(self.basepath)-2:len(self.basepath)-1]=="\\":
                f=self.basepath[0:len(self.basepath)-2]+f
            else:
                f=self.basepath+f
        return f

    def checkFolder(self,f):
        if f == None:
            return False
        else:
            if isLinux():
                if f.find("/")==0:
		            pass
                else:
                    f="/"+f
                if self.basepath[len(self.basepath)-2:len(self.basepath)-1]=="/":
                    f=self.basepath[0:len(self.basepath)-2]+f
                else:
                    f=self.basepath+f
            else:
                if f.find("\\")==0:
                    pass
                else:
                    f="\\"+f
                if self.basepath[len(self.basepath)-2:len(self.basepath)-1]=="\\":
                    f=self.basepath[0:len(self.basepath)-2]+f
                else:
                    f=self.basepath+f

        if os.path.isdir(f):
            return True
        return False
        pass
    
    def fileCountIn(self,dir):
        return sum([len(files) for root,dirs,files in os.walk(dir)])
    
    # f.get("type"),f.get("ismust"),f.get("checkitem"),f.get("condition"),f.text
    def check(self):
        allPass=True
        resultbase="check base path is :\n" + self.basepath + "\n\n"
        
        for f in self.fileitems:
            erroroccor=False
            #realPath=self.fp.getRealPath(os.path.join(basepath,f.getPath()))
            realPath=self.fp.getRealPath(f.getPath())
            #result+=realPath
            #print str(f.getPath()) + "real path is " + str(realPath)
            # check if file exist
            if f.getStype() == "file":
                if self.checkFile(realPath):
                    pass
                else:
                    erroroccor=True
                    result=realPath+" folder not exist! \n"
                    f.setCheckresult(result)
                    if int(f.getIsmust())==0:
                        result+="ommit"
                        pass
                    else:
                        allPass=False
                        #result+=" ismust== "+ str(f.getIsmust())+"\n"
                    continue
                pass
            elif f.getStype() == "folder":
                if self.checkFolder(realPath):
                    pass
                else:
                    erroroccor=True
                    result=realPath+" folder not exist!\n"
                    f.setCheckresult(result)
                    if int(f.getIsmust())==0:
                        result+="ommit"
                        pass
                    else:
                        allPass=False
                        #result+=" ismust== "+ str(f.getIsmust())+"\n"
                    continue
                pass
            else:
                print "exception please check if config error accour\n"
                continue
            # record ismust
            # checkitem
            fi=f.getCheckItemNum()
            #print "file count is " + str(fi)
            #print "f is must=="+str(f.getIsmust())
            #print "f is path=="+str(f.getPath()) + str(realPath)
            count=self.fileCountIn(self.getRealPath(realPath))
            #print f.getPath()+" check num is " +str(fi)+"count is " + str(count)+ str(erroroccor)
            if fi==1:
                # check subfiles
                #print "fi==1" + realPath + "count " + str(count)
                if count>0:
                    pass
                else:
                    if int(f.getIsmust())==0:
                        result=realPath+" folder has no subfiles ommit\n"
                        f.setCheckresult(result)
                        pass
                    else:
                        erroroccor=True
                        result=realPath+" folder has no subfiles\n"
                        f.setCheckresult(result)
                        allPass=False
                    pass
                    
                    pass
                pass
            # check condition > < = logical
            elif fi==2:
                #print realPath
                if f.doCondition(count):
                    pass
                else:
                    if int(f.getIsmust())==0:
                        result=realPath+" check condtion count "+f.getCondition()+" can not meet the desire,ommit\n"
                        f.setCheckresult(result)
                        pass
                    else:
                        erroroccor=True
                        result=realPath+" check condition count "+f.getCondition()+" can not meet the desire \n"
                        f.setCheckresult(result)
                        allPass=False
                    pass
                pass
            elif fi==3:
                #if realPath[-2:]=="bt" or realPath[-2:]=="p2":
                #    print "deal with"
                # foldersize check
                size = getdirsize(self.getRealPath(realPath))
                #print " " + str(self.getRealPath(realPath)) + " size is " + str(size)
                if size>0:
                    pass
                else:
                    if int(f.getIsmust())==0:
                        result=realPath+" size is 0 can not meet the desire,ommit\n"
                        f.setCheckresult(result)
                        pass
                    else:
                        erroroccor=True
                        result=realPath+" size is 0 can not meet the desire,ommit\n"
                        f.setCheckresult(result)
                        allPass=False
                    pass
            else:
                pass
            if erroroccor:
                #result=realPath+result
                erroroccor=False
        # dic store result <checktype results>
        results_dic={}
        # get result from items
        for f in self.fileitems:
            if f.getCheckresult() != "":
                if results_dic.get(f.getChecktype(),"notexist") == "notexist":
                    results_dic[f.getChecktype()]=f.getCheckresult()
                else:
                    results_dic[f.getChecktype()]=f.getCheckresult() + results_dic.get(f.getChecktype())
        # get result from dict
        result=resultbase
        for (d,x) in results_dic.items():
            result +=d + " check result:\n" +str(x) + "\n"
                    
        return allPass,result
        pass
    
def printUsage():
    print
    print "  usage: " + sys.argv[0] + " [options] [baselogpath]"
    print
    sys.exit(1)                                            
    pass
# input the fake folder and get the real folder
# command mode
# get filecount foldercount filetostr[split by ","] foldertostr[split by ","] realPath 
# style concole output
if __name__ == "__main__":
    #basepath="/home/apuser/task/logframework/docs/306738/slog_20140603193225_sp7730ec_userdebug"
    
    if len(sys.argv) > 2:
        printUsage()
    basepath=""
    if len(sys.argv)==2:
        basepath=sys.argv[1]
    print basepath
    lc=LogCheck(basepath)
    result=lc.check()
    #print result
    if result[0]:
        print "PASS: no file lost!"
        print result[1]
    else:
	    print "FAIL:file lost! detail info"
	    print result[1]

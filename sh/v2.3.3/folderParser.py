# -*- coding:utf-8 -*-
'''
Created on Jun 26, 2014

@author: gary.gong
'''
import getopt
import os
import os.path
import sys
from configParser import ConfigParser
import platform

def isLinux():
    sysstr = platform.system()
    if(sysstr == "Windows"):
        return False
    elif(sysstr == "Linux"):
        return True
    else:
        return False
    
# keyword=raw_input(u"请输入关键词".encode("gb2312"))
# 
class FolderParser(object):
    '''
    classdocs
    '''

    def __init__(self, logfolder):
        '''
        Constructor
        '''
        # store the real path to a file
        self.storefile = "tmp/latest_log_path"
        # static defined variable
        self.dateinternal = "DATE_INTERNAL";
        self.dateinternal_lastlog = "DATEINTERNAL_LASTLOG";
        self.dateexternal = "DATE_EXTERNAL";
        self.dateexternal_lastlog = "DATEEXTERNAL_LASTLOG";
        # store the fade and real path map
        self.mapfadereal = {}
        self.initdata()
        self.logfolder = logfolder
        if self.logfolder == None or self.logfolder == "":
            self.logfolder = self.getLogPath()
        self.fullfilepaths = []
        self.fullfolderpaths = []
        self.cp = ConfigParser("configs/config.xml")
        self.workpath()
        
        
    def initdata(self):
        self.mapfadereal[self.dateinternal] = ""
        self.mapfadereal[self.dateinternal_lastlog] = ""
        self.mapfadereal[self.dateexternal] = ""
        self.mapfadereal[self.dateexternal_lastlog] = ""
        pass

    def printData(self):
        print self.mapfadereal[self.dateinternal]
        print self.mapfadereal[self.dateinternal_lastlog]
        print self.mapfadereal[self.dateexternal]
        print self.mapfadereal[self.dateexternal_lastlog]

    # return the log path if no basepath passed
    def getLogPath(self):
        if self.logfolder == None or self.logfolder == "":
            f = open(self.storefile, "r")
            path = f.readline()
            # get current path
            return path.strip()
        else:
            return self.logfolder
    
    # return report folder
    def getReportPath(self):
        logpath = self.getLogPath()
        if isLinux():	
            result = logpath.split("/")
        else:
            result = logpath.split("\\")
        path = result[len(result) - 1]
        if path == "":
            path = result[len(result) - 2]
        if path == "":
            path = "xx_unknow_"
        #  get current path
        os.path.abspath('.')
        if isLinux():
            return os.path.abspath('.') + "/report/" + path.split("_")[1]
        else:
            return os.path.abspath('.') + "\\report\\" + path.split("_")[1]
    
    def workpath(self):
        for parent, dirnames, filenames in os.walk(self.logfolder):  # 三个参数：分别返回1.父目录 2.所有文件夹名字（不含路径） 3.所有文件名字
            for dirname in  dirnames:  # 输出文件夹信息
                # print "parent is:" + parent
                # check if endwith external_storage
                # check if endwith external_storage
                # print  "dirname is" + dirname
                # internal_storage
                # internal_storage/last_log
                # internal_storage/2014-06-03-19-27-04
                if parent.endswith('external_storage'):
                    if dirname != 'last_log' and dirname.find("-")>0:
                        self.mapfadereal[self.dateexternal] = dirname
                elif parent.endswith('last_log'):
                    if parent.find("external_storage") > 0:
                        self.mapfadereal[self.dateexternal_lastlog] = dirname
                    elif parent.find("internal_storage") > 0:
                        self.mapfadereal[self.dateinternal_lastlog] = dirname
                        pass
                if parent.endswith('internal_storage'):
                    if dirname != 'last_log' and dirname.find("-")>0:
                        self.mapfadereal[self.dateinternal] = dirname
                self.fullfolderpaths.append(os.path.join(parent, dirname))
            #self.printData()
            for filename in filenames:  # 输出文件信息
                # print "parent is"+ parent
                # print "filename is:" + filename
                # print "the full name of the file is:" + os.path.join(parent,filename) #输出文件路径信息
                self.fullfilepaths.append(os.path.join(parent, filename))
    
    def getmap(self):
        return self.mapfadereal
    
    def getfiles(self):
        return self.fullfilepaths
    
    def getfilesToStr(self):
        return ",".join(self.fullfilepaths)
      
    def getfolder(self):
        return self.fullfolderpaths
    
    def getfolderToStr(self):
        return ",".join(self.fullfolderpaths)
    
    def printmap(self):
        print self.mapfadereal
        
    def printfiles(self):
        print self.fullfilepaths
        
    def printdirs(self):
        print self.fullfolderpaths
        
    def getFileCount(self):
        return len(self.fullfilepaths)
    
    def getFolderCount(self):
        return len(self.fullfolderpaths)
        pass
    
    def getAnrFiles(self):
        typename = "anr"
        self.getFilesBy(typename)
        pass
    
    # return the string list of files with "," split
    def getFilesBy(self, typeName):
        files = self.cp.getProblemFiles(typeName)
        tmprefiles = []
	#print files
        # get all path meeted files
        for i in self.fullfilepaths:
            for f in files:
                #print "xx"+f.getPath()
                #print "yy"+self.getRealPath(f.getPath())
                pp=""
                if not isLinux():
                    pp=f.getPath().replace("/","\\")
                else:
                    pp=f.getPath().replace("\\","/")
                #print self.getRealPath(pp)
		#print i
                if i.find(self.getRealPath(pp)) >= 0:
                    # check items
                    chk = f.getCheckitem()
		    #print "chk" + str(chk)
                    if chk == "" or chk == None:
                        tmprefiles.append(i)
                    else:
                        for ii in chk.split(","):
                            if i.find(ii) >= 0:
                                tmprefiles.append(i)
                                break
			break
        return ",".join(tmprefiles)
        pass
    
    def __checkComplete(self, f):
        realPath = f
        if realPath.find(self.dateinternal) >= 0:
            return None
        if realPath.find(self.dateinternal_lastlog) >= 0:
            return None
        if realPath.find(self.dateexternal) >= 0:
            return None
        if realPath.find(self.dateexternal_lastlog) >= 0:
            return None
        '''
        if isLinux():
            if f.find("/")==0:
	            pass
            else:
                f="/"+f
            if self.logfolder[len(self.logfolder)-2:len(self.logfolder)-1]=="/":
                f=self.logfolder[0:len(self.logfolder)-2]+f
            else:
                f=self.logfolder+f
        else:
            if f.find("\\")==0:
                pass
            else:
                f="\\"+f
            if self.logfolder[len(self.logfolder)-2:len(self.logfolder)-1]=="\\":
                f=self.logfolder[0:len(self.logfolder)-2]+f
            else:
                f=self.logfolder+f
        '''
        return  f
        #return os.path.join(self.logfolder, realPath)
     
    # return null if file path is not exist
    def getRealPath(self, fadepath):
        result = fadepath
        if result == "" or result == None:
            return ""
        for (k, v) in self.mapfadereal.items():
            # print k,v
            if v == "":
                result = result.replace(k, "nofolderfound")
            else:
                result = result.replace(k, v)
            # print result
            pass
        return self.__checkComplete(result)
        pass
    
def printUsage():
    print
    print "  usage: " + sys.argv[0] + " [options] [baselogpath]"
    print
    print "  --getrealpath=virtualpath"
    print "       get the real path of the beaselogpath from virtualpath"
    print
    print "  --showpaths"
    print "       show all the files in baselogpath"
    print
    print "  --showfolders"
    print "       show all folder in baselogpath"
    print "  --getproblemfiles"
    print "       get the specific files in baselogpath"
    print
    print "  baselogpath is the root path of catched log "
    print
    sys.exit(1)
    pass
# input the fake folder and get the real folder
# command mode
# get filecount foldercount filetostr[split by ","] foldertostr[split by ","] realPath 
# style concole output
if __name__ == "__main__":
    basepath = "/home/apuser/task/logframework/docs/306738/slog_20140603193225_sp7730ec_userdebug"
    
    try:
        options, arguments = getopt.getopt(sys.argv[1:], "",
                             ["getpaths", "getrealpath=", "getfolders", "getproblemfiles=", "getlogpath", "getreportpath", "help"])
    except getopt.GetoptError, error:
        printUsage()
    
    if len(arguments) > 1:
        printUsage()
        
    try:
        basepath = arguments[0]
    except:
        basepath = None

    fp = FolderParser(basepath)
    # fp.printmap()
    for option, value in options:
        if option == "--getpaths":
            # print "showpaths"
            print fp.getfilesToStr()
        elif option == "--getfolders":
            print fp.getfolderToStr()
        elif option == "--help":
            printUsage()
        elif option == "--getrealpath":
            realPath = value
            print fp.getRealPath(realPath)
        elif option == "--getproblemfiles":
            problemkey = value
            print fp.getFilesBy(problemkey)
        elif option == "--getlogpath":
            print fp.getLogPath()
            pass
        elif option == "--getreportpath":
            print fp.getReportPath()
            pass
        
  
    
    
        

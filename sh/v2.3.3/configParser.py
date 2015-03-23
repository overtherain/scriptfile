# -*- coding:utf-8 -*-
import xml.etree.ElementTree as et
import os
from fileItem import FileItem
'''
Created on Jun 26, 2014

@author: gary.gong
'''

class ConfigParser:
    
    def __init__(self,configfile):
        self.configfile=configfile
        self.root=et.parse(configfile).getroot()
        pass
    
    # get text value in tree view 
    def parserSingle(self,item):
        nodes=item.split("/")
        length = len(nodes)
        self.node=self.root
        for i in range(length):
            self.node=self.node.find(nodes[i])
        return self.node.text
        pass
    # get checkItems
    def getCheckItems(self):
        checkfileNode=self.root.find("checkfile")
        files=checkfileNode.findall("file")
        fArr=[]
        # stype="file",ismust=0,checkitem="",condition="",path=""
        for f in files:
            #print f.get("type"),f.get("ismust"),f.get("checkitem"),f.get("condition"),f.text
            ff=FileItem(f.get("type"),f.get("ismust"),f.get("checkitem"),f.get("condition"),f.text,f.get("checktype"))
            fArr.append(ff)
            pass
        return fArr
    
    def getProblemneededfiles(self,problemtype):
        return self.getProblemFiles(problemtype)
        pass
    
    def getProblemFiles(self,problemtype):
        problems=self.getProblems()
        files=[]
        ffs=None
        for p in problems:
            if p.get("type") == problemtype:
                # here get all file list
                ffs=p.findall("file")
                break
        if ffs !=None:
            for x in ffs:
                ff=FileItem(x.get("type"),"",x.get("checkitem"),"",x.text)
                files.append(ff)
            pass
        return files
        pass
    def getProblems(self):
        problemneedfilenode=self.root.find("problemneededfile")
        return problemneedfilenode.findall("problem")
        
if __name__ == "__main__":
    cp = ConfigParser("configs/config.xml")
    print cp.parserSingle("update/autoupdate")
    checkresult=""
    for f in cp.getCheckItems():
        f.toStr()
    xx=cp.getProblemneededfiles("anr")
    for x in xx:
        print x.getStype(),x.getCheckitem(),x.getPath()
    pass
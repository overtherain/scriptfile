'''
Created on Jun 30, 2014

@author: gary.gong
'''

class FileItem(object):
    '''
    used for file complition check
    '''


    def __init__(self,stype="file",ismust=0,checkitem="",condition="",path="",checktype="default"):
        '''
        Constructor
        '''
        self.stype=stype
        self.ismust=ismust
        self.checkitem=checkitem
        self.condition=condition
        self.path=path
        self.checktype=checktype
        self.checkresult=""
        pass
    
    def setCheckresult(self,checkresult):
        self.checkresult=checkresult
        
    def getCheckresult(self):
        return self.checkresult
        
    def setChecktype(self,checktype):
        self.checktype=checktype
    
    def getChecktype(self):
        return self.checktype
            
    def setStype(self,stype):
        self.stype=stype
    
    def getStype(self):
        return self.stype
    
    def setIsmust(self,ismust):
        self.ismust=ismust
        
    def getIsmust(self):
        return self.ismust
    
    def setCheckitem(self,checkitem):
        self.checkitem=checkitem
        
    def getCheckitem(self):
        return self.checkitem
    
    def setCondition(self,condition):
        self.condition=condition
    
    def getCondition(self):
        return self.condition
    
    def doCondition(self,pre):
        return eval(str(pre)+self.condition)
    
    def getPath(self):
        return self.path
    
    def setPath(self,path):
        self.path=path
        
    def getCheckItemNum(self):
        if self.checkitem=="exist":
            return 0
        if self.checkitem=="hassubfiles":
            return 1
        if self.checkitem=="subfilescount":
            return 2
        if self.checkitem=="foldersize":
            return 3


        
    def checkPath(self,realPath):
        result="check path is " + realPath
        # check if file exist
        if realPath=="":
            return 
        return 
    
    def toStr(self):
        print str(self.stype) + str(self.ismust) + str(self.checkitem) + str(self.condition)+str(self.path)
        
if __name__ == "__main__":
    fi = FileItem()
    fi.setCondition(">=3")
    print fi.doCondition("2")
    print fi.doCondition("3")
    print fi.doCondition("4")  
    pass
    

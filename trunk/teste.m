clear;
load('D:\AcadÍmico\Codes\Deep Learning\dlpso\digittraindata.mat', 'digitdata');
load('D:\AcadÍmico\Codes\Deep Learning\dlpso\vishid.mat', 'vishid');
load('D:\AcadÍmico\Codes\Deep Learning\dlpso\hidrecbiases.mat', 'hidrecbiases');
load('D:\AcadÍmico\Codes\Deep Learning\dlpso\visbiases.mat', 'visbiases');
data = digitdata;
numdims = 784;
numhid = 500;
rbmde;
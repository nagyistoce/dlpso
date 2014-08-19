load('D:\Acad�mico\Codes\Deep Learning\dlpso\digittraindata.mat', 'digitdata');

load('D:\Acad�mico\Codes\Deep Learning\dlpso\batchdata.mat', 'batchdata');

load('D:\Acad�mico\Codes\Deep Learning\dlpso\vishid.mat', 'vishid');
load('D:\Acad�mico\Codes\Deep Learning\dlpso\hidrecbiases.mat', 'hidrecbiases');
load('D:\Acad�mico\Codes\Deep Learning\dlpso\visbiases.mat', 'visbiases');

% load('D:\Acad�mico\Codes\Deep Learning\dlpso\vishidRBM.mat', 'vishidRBM');
% load('D:\Acad�mico\Codes\Deep Learning\dlpso\hidbiasesRBM.mat', 'hidbiasesRBM');
% load('D:\Acad�mico\Codes\Deep Learning\dlpso\visbiasesRBM.mat', 'visbiasesRBM');
 
% load('D:\Acad�mico\Codes\Deep Learning\dlpso\vishid2.mat', 'vishid2');
% load('D:\Acad�mico\Codes\Deep Learning\dlpso\hidrecbiases2.mat', 'hidbiases2');
% load('D:\Acad�mico\Codes\Deep Learning\dlpso\visbiases2.mat', 'visbiases2');

% load('D:\Acad�mico\Codes\Deep Learning\dlpso\visbiasesBatchPSO.mat', 'visbiasesBatchPSO');
% load('D:\Acad�mico\Codes\Deep Learning\dlpso\hidbiasesBatchPSO.mat', 'hidbiasesBatchPSO');
% load('D:\Acad�mico\Codes\Deep Learning\dlpso\vishidBatchPSO.mat', 'vishidBatchPSO');

data = digitdata;
numbatches = 600;
numcases = 100;
numdims = 784;
numhid = 500;
[numcases numdims numbatches]=size(batchdata);
disp(datestr(now));
rbmde;
disp(datestr(now));
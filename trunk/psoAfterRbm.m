% Version 1.000 
%
% Code provided by Geoff Hinton and Ruslan Salakhutdinov 
%
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our
% web page.
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.

% This program trains Restricted Boltzmann Machine in which
% visible, binary, stochastic pixels are connected to
% hidden, binary, stochastic feature detectors using symmetrically
% weighted connections. Learning is done with 1-step Contrastive Divergence.   
% The program assumes that the following variables are set externally:
% maxepoch  -- maximum number of epochs
% numhid    -- number of hidden units 
% batchdata -- the data that is divided into batches (numcases numdims numbatches)
% restart   -- set to 1 if learning starts from beginning 

epsilonw      = 0.1;   % Learning rate for weights 
epsilonvb     = 0.1;   % Learning rate for biases of visible units 
epsilonhb     = 0.1;   % Learning rate for biases of hidden units 
weightcost  = 0.0002;   
initialmomentum  = 0.5;
finalmomentum    = 0.9;

[numcases numdims numbatches]=size(batchdata);

if restart ==1,
  restart=0;
  epoch=1;

% Initializing symmetric weights and biases. 
  vishid     = 0.1*randn(numdims, numhid);
  hidbiases  = zeros(1,numhid);
  visbiases  = zeros(1,numdims);

  poshidprobs = zeros(numcases,numhid);
  neghidprobs = zeros(numcases,numhid);
  posprods    = zeros(numdims,numhid);
  negprods    = zeros(numdims,numhid);
  vishidinc  = zeros(numdims,numhid);
  hidbiasinc = zeros(1,numhid);
  visbiasinc = zeros(1,numdims);
  batchposhidprobs=zeros(numcases,numhid,numbatches);
end

for epoch = epoch:maxepoch,
 fprintf(1,'epoch %d\r',epoch); 
 errsum=0;
 for batch = 1:numbatches,
 %fprintf(1,'epoch %d batch %d\r',epoch,batch); 

%%%%%%%%% START POSITIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  data = batchdata(:,:,batch);
  poshidprobs = 1./(1 + exp(-data*vishid - repmat(hidbiases,numcases,1)));    
  batchposhidprobs(:,:,batch)=poshidprobs;
  posprods    = data' * poshidprobs;
  poshidact   = sum(poshidprobs);
  posvisact = sum(data);

%%%%%%%%% END OF POSITIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  poshidstates = poshidprobs > rand(numcases,numhid);

%%%%%%%%% START NEGATIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  negdata = 1./(1 + exp(-poshidstates*vishid' - repmat(visbiases,numcases,1)));
  neghidprobs = 1./(1 + exp(-negdata*vishid - repmat(hidbiases,numcases,1)));    
  negprods  = negdata'*neghidprobs;
  neghidact = sum(neghidprobs);
  negvisact = sum(negdata); 

%%%%%%%%% END OF NEGATIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  err= sum(sum( (data-negdata).^2 ));
  errsum = err + errsum;

   if epoch>5,
     momentum=finalmomentum;
   else
     momentum=initialmomentum;
   end;

%%%%%%%%% UPDATE WEIGHTS AND BIASES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    vishidinc = momentum*vishidinc + ...
                epsilonw*( (posprods-negprods)/numcases - weightcost*vishid);
    visbiasinc = momentum*visbiasinc + (epsilonvb/numcases)*(posvisact-negvisact);
    hidbiasinc = momentum*hidbiasinc + (epsilonhb/numcases)*(poshidact-neghidact);

    vishid = vishid + vishidinc;
    visbiases = visbiases + visbiasinc;
    hidbiases = hidbiases + hidbiasinc;

%%%%%%%%%%%%%%%% END OF UPDATES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

  end
  fprintf(1, 'epoch %4i error %6.1f  \n', epoch, errsum); 
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PSO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('D:\Acadêmico\Codes\Deep Learning\dlpso\digittraindata.mat', 'digitdata');
data = digitdata;
numdims = 784;
numhid = 500;

%pso parameters
swarmSize = 3; %swarm size 10 
dimension = (numdims * numhid) + numdims + numhid;
xMax = 1;
xMin = -1;
vmax = 1;
w = 0.9; %inertia weight (momentum term)
c1 = 2.05;
c2 = 2.05; %individual and global acceleration coefficients
iterMax = 20; %10
maxCountStopCriteria = 100;

disp('PSO initialiazation');
fprintf('Swarm size: %d\n', swarmSize);

swarm = zeros(dimension, swarmSize);
swarm(:, 1) = [visbiases hidbiases reshape(vishid,numdims*numhid,1)'];
for i=2:swarmSize
    swarm(:, i) = swarm(:, 1) + ((0.1 - (-0.1)) * randn(1,1));
end


lbest = 0.1*randn(dimension, swarmSize);
v = 1 * ones(dimension, swarmSize);


fitnessLbest = 1000000000000 * ones(1,swarmSize);
for i=1:swarmSize 
    particle = lbest(:, i);
    rbm_aux;
    fitnessLbest(1, i) = err;    
end
fitnessGbest = 1000000000000;

fits = zeros(iterMax, swarmSize);

countStopCriteria = 1;
for iter=1:iterMax %each iteration        
    fprintf('PSO Iteration: %d\n', iter);
    previousFitnessGbest = fitnessGbest;
    for i=1:swarmSize %each particle
        %fprintf('Particle: %d\n', i);
        particle = swarm(:, i);       

        rbm_aux;
        fitness = err;
        
        fits(iter, i) = fitness;
                
        if (fitness < fitnessLbest(1, i))            
            lbest(:, i) = particle;
            fitnessLbest(1, i) = fitness; 
        end
        if (fitnessLbest(1, i) < fitnessGbest)            
            gbest = lbest(:, i);            
            fitnessGbest = fitnessLbest(1, i);    
            poshidprobsGbest = poshidprobs;
        end
    end    
    for i=1:swarmSize 
        for j=1:dimension %each dimension
            part1 = c1 * round(rand) * (lbest(j, i) - particle(j));
            part2 = c2 * round(rand) * (gbest(j) - particle(j));
            v(j, i) = w * v(j, i) + part1 + part2;
            swarm(j, i) = particle(j) + v(j, i);
        end 
    end
    w = w - 0.5 / iterMax; %w decreases linearly
    fprintf('Fitness GBEST: %f\n', fitnessGbest);
    if previousFitnessGbest == fitnessGbest
        countStopCriteria = countStopCriteria + 1;
    else
        countStopCriteria = 0;
    end
    if countStopCriteria > maxCountStopCriteria
        break;
    end    
end

visbiases   = gbest(1:numdims)';
hidbiases   = gbest((numdims+1):(numdims+numhid))';
vishid      = vec2mat(gbest((numdims+numhid+1):end),numdims)';
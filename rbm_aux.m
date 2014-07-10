epsilonw      = 0.1;   % Learning rate for weights 
epsilonvb     = 0.1;   % Learning rate for biases of visible units 
epsilonhb     = 0.1;   % Learning rate for biases of hidden units 
weightcost  = 0.0002;   
initialmomentum  = 0.5;
finalmomentum    = 0.9;

% Initializing symmetric weights and biases. 
%vishid     = 0.1*randn(numdims, numhid);
%hidbiases  = zeros(1,numhid);
%visbiases  = zeros(1,numdims);
visbiases   = particle(1:numdims)';
hidbiases   = particle((numdims+1):(numdims+numhid))';
%vishid      = vec2mat(particle((numdims+numhid+1):end),numdims)';
vishid = particle((numdims+numhid+1):end);

%This will "copy" most of the vec2mat behavior
% c is the original vector, matrix, nc is the number of columns:
vishid = reshape([vishid(:) ; zeros(rem(numdims - rem(numel(vishid),numdims),numdims),1)],numdims,[]);

numcases = size(data, 1);

poshidprobs = zeros(numcases,numhid);
neghidprobs = zeros(numcases,numhid);
posprods    = zeros(numdims,numhid);
negprods    = zeros(numdims,numhid);
%vishidinc  = zeros(numdims,numhid);
%hidbiasinc = zeros(1,numhid);
%visbiasinc = zeros(1,numdims);
%batchposhidprobs=zeros(numcases,numhid,numbatches);

 %for batch = 1:numbatches,
 %fprintf(1,'epoch %d batch %d\r',epoch,batch); 

%%%%%%%%% START POSITIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %data = batchdata(:,:,batch);
  poshidprobs = 1./(1 + exp(-data*vishid - repmat(hidbiases,numcases,1)));    
  %batchposhidprobs(:,:,batch)=poshidprobs;
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
  

  
 %end
  

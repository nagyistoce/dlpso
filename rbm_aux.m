load('mnistvhclassify')
% Initializing symmetric weights and biases. 
%visbiases   = particle(1:numdims)'*0.0002;
%hidbiases   = particle((numdims+1):(numdims+numhid))';
hidbiases = hidrecbiases;
%vishid      = vec2mat(particle((numdims+numhid+1):end),numdims)';
%vishid = particle((numdims+numhid+1):end);

%This will "copy" most of the vec2mat behavior
% c is the original vector, matrix, nc is the number of columns:
%vishid = reshape([vishid(:) ; zeros(rem(numdims - rem(numel(vishid),numdims),numdims),1)],numdims,[]);

numcases = size(data, 1);

poshidprobs = zeros(numcases,numhid);

%%%%%%%%% START POSITIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
poshidprobs = 1./(1 + exp(-data*vishid - repmat(hidbiases,numcases,1)));      
  
%%%%%%%%% END OF POSITIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
poshidstates = poshidprobs > rand(numcases,numhid);

%%%%%%%%% START NEGATIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
negdata = 1./(1 + exp(-poshidstates*vishid' - repmat(visbiases,numcases,1)));
 
%%%%%%%%% END OF NEGATIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
err= sum(sum( (data-negdata).^2 ));
  

  
  

load('mnistvhclassify')
% Initializing symmetric weights and biases. 
visbiases   = particle(1:numdims)'*0.0002;
hidbiases   = particle((numdims+1):(numdims+numhid))';
%vishid      = vec2mat(particle((numdims+numhid+1):end),numdims)';
vishid = particle((numdims+numhid+1):end);
vishid = reshape([vishid(:) ; zeros(rem(numdims - rem(numel(vishid),numdims),numdims),1)],numdims,[]);

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
  

  
  

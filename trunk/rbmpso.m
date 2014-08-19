%pso parameters
swarmSize = 5; %swarm size 10 
dimension = (numdims * numhid) + numdims + numhid;
xmax = 1;
xmin = -1;
vmax = 0.1;
vmin = -0.1;
w = 0.9; %inertia weight (momentum term)
c1 = 2.05;
c2 = 2.05; %individual and global acceleration coefficients
iterMax = 20; %10
maxCountStopCriteria = 100;

disp('PSO initialiazation');
fprintf('Swarm size: %d\n', swarmSize);

% swarm = zeros(dimension, swarmSize);
% v     = zeros(dimension, swarmSize); 
% lbest = zeros(dimension, swarmSize); 
% for i=1:swarmSize
%    for j=1:dimension
%        swarm(j, i) = xmin + (xmax - xmin) * rand;
%        lbest(j, i) = xmin + (xmax - xmin) * rand;
%        v(j, i) = (-vmax/3) + ((vmax/3) - (-vmax/3)) * rand;
%    end    
%    %lbest(:, i) = swarm(:, i);
% end
%swarm = randn(dimension, swarmSize);
swarm = 0.1*randn(dimension, swarmSize);
%swarm = normrnd(0.03,0.2,dimension,swarmSize);
%swarm(:, 1) = [visbiasesBatchPSO hidbiasesBatchPSO reshape(vishidBatchPSO,numdims*numhid,1)'];
swarm(:, 1) = [visbiases hidrecbiases reshape(vishid,numdims*numhid,1)'];
swarm(:, 2) = [visbiases+0.1*randn(1, numdims) hidrecbiases+0.1*randn(1, numhid) reshape(vishid,numdims*numhid,1)'+0.1*randn(1, numdims*numhid)];
swarm(:, 3) = [visbiases+0.1*randn(1, numdims) hidrecbiases+0.1*randn(1, numhid) reshape(vishid,numdims*numhid,1)'+0.1*randn(1, numdims*numhid)];
swarm(:, 4) = [visbiases+0.1*randn(1, numdims) hidrecbiases+0.1*randn(1, numhid) reshape(vishid,numdims*numhid,1)'+0.1*randn(1, numdims*numhid)];
swarm(:, 5) = [visbiases+0.1*randn(1, numdims) hidrecbiases+0.1*randn(1, numhid) reshape(vishid,numdims*numhid,1)'+0.1*randn(1, numdims*numhid)];
%lbest = 0.1*randn(dimension, swarmSize);
lbest = swarm;
%gbest = 0.1*ones(dimension);
v = 0.1*randn(dimension, swarmSize);
%v = normrnd(0.03,0.2,dimension,swarmSize);


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
            if v(j, i) > vmax
                v(j, i) = 1;
            elseif v(j, i) < vmin
                v(j, i) = -1;                
            end
            swarm(j, i) = particle(j) + v(j, i);
        end 
    end
%     for i=1:swarmSize        
%         part1 = c1 * round(rand) * (lbest(:, i) - particle);
%         part2 = c2 * round(rand) * (gbest - particle);
%         v(:, i) = w * v(:, i) + part1 + part2;
%         for j=1:dimension 
%             if v(j, i) > vmax
%                 v(j, i) = 1;
%             elseif v(j, i) < vmin
%                 v(j, i) = -1;                
%             end
%         end
%         swarm(:, i) = particle + v(:, i);
%     end
    w = w - 0.5 / iterMax; %w decreases linearly
    fprintf('Fitness GBEST: %f\n', fitnessGbest);
    disp(fits);
    disp(mean(v));
    disp(max(v));
    disp(min(v));
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




%         if firstLayer == 1
%             k = randperm(size(digitdata,1));
%             data = digitdata(k(1:numbatches),:);
%         end   





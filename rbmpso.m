%pso parameters
swarmSize = 2; %swarm size 10 
dimension = (numdims * numhid) + numdims + numhid;
swarm = 0.1*randn(dimension, swarmSize);
lbest = 0.1*randn(dimension, swarmSize);
%gbest = 0.1*ones(dimension);
v = 0.1 * ones(dimension, swarmSize);
w = 0.9; %inertia weight (momentum term)
c1 = 2.05;
c2 = 2.05; %individual and global acceleration coefficients
iterations = 1; %10

disp('PSO initialiazation');

fitnessLbest = zeros(1,swarmSize);
for i=1:swarmSize 
    particle = lbest(:, i);
    
%     if firstLayer == 1
%         k = randperm(size(digitdata,1));
%         data = digitdata(k(1:numbatches),:);
%     end   
    
    rbm_aux;
    fitnessLbest(1, i) = err;    
end
fitnessGbest = 1000000000000;

for iter=1:iterations %each iteration    
    fprintf('PSO Iteration: %d\n', iter);
    for i=1:swarmSize %each particle
        fprintf('Particle: %d\n', i);
        particle = swarm(:, i);
        
%         if firstLayer == 1
%             k = randperm(size(digitdata,1));
%             data = digitdata(k(1:numbatches),:);
%         end   
        rbm_aux;
        fitness = err;
        
        if (fitness < fitnessLbest(1, i))            
            lbest(:, i) = particle;
            fitnessLbest(1, i) = fitness; 
        end
        if (fitnessLbest(1, i) < fitnessGbest)            
            gbest = lbest(:, i);
            fitnessGbest = fitnessLbest(1, i);    
            poshidprobsGbest = poshidprobs;
        end
        
        for j=1:dimension %each dimension
            part1 = c1 * round(rand) * (lbest(j, i) - particle(j));
            part2 = c2 * round(rand) * (gbest(j) - particle(j));
            v(j, i) = w * v(j, i) + part1 + part2;
            swarm(j, i) = particle(j) + v(j, i);
        end
        w = w - 0.5 / iterations; %w decreases linearly
        fprintf('Fitness GBEST: %f\n', fitnessGbest);
    end    
end

visbiases   = gbest(1:numdims)';
hidbiases   = gbest((numdims+1):(numdims+numhid))';
vishid      = vec2mat(gbest((numdims+numhid+1):end),numdims)';





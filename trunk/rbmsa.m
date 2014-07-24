swarmSize = 3;
dimension = (numdims * numhid) + numdims + numhid;

disp('SA initialiazation');
fprintf('Swarm size: %d\n', swarmSize);

lbest = 0.1*randn(dimension, swarmSize);
fitnessLbest = ones(1,swarmSize);
for i=1:swarmSize 
    particle = lbest(:, i);
    rbm_aux;
    fitnessLbest(1, i) = err;    
end
fitnessGbest = 1000000000000;

xMax = 1;
xMin = -1;
sigmaMin = 0.1; 
sigmaMax = 1; 

tp0 = 100;
tpFinal = 10;
tpRate = 0.85;

iterMax = 20;
fits = zeros(iterMax, swarmSize);

tp = tp0;
iter = 1;
while (tp > tpFinal)    
    fprintf('SA Iteration: %d\n', iter);
    for i=1:swarmSize        
        lbestNew = zeros(dimension, 1); 
        sigma = sigmaMax - ((sigmaMax - sigmaMin) * (tp / tp0));
        gaussian = sigma.*randn(1,1);
        lbestNew = lbest(:, i);
        
        for j=1:dimension
            lbestNew(j, 1) = lbestNew(j, 1) + ((xMax - xMin) * gaussian);
        end 
                
        particle = lbestNew;       
        rbm_aux;
        fitness = err;
        fits(iter, i) = fitness;
        if (fitness < fitnessLbest(1, i)) 
            lbest(:, i) = lbestNew;
            fitnessLbest(1, i) = fitness;  
        else
            delta = ((fitness - fitnessLbest(1, i)) / fitness) * 100;
            P = exp ((delta/tp) * -1);
            
            if (rand < P)                 
                lbest(:, i) = lbestNew;
                fitnessLbest(1, i) = fitness; 
            end
        end
        
        if (fitnessLbest(1, i) < fitnessGbest)            
            gbest = lbest(:, i);            
            fitnessGbest = fitnessLbest(1, i);                
        end
    end
    fprintf('Fitness GBEST: %f\n', fitnessGbest);
    iter = iter + 1;
    tp = tpRate * tp;
end
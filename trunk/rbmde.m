populationSize = 5;
dimension = (numdims * numhid) + numdims + numhid;
iterMax = 10;
F = 0.5;
Cr = 0.9;

population = 0.1*randn(dimension, populationSize);
xoff = zeros(dimension, populationSize);
replacementIndexes = zeros(1, populationSize);
fitness = zeros(1, populationSize);

fits = zeros(iterMax, populationSize);

for iter=1:iterMax        
    
    
    for k=1:populationSize        
        particle = population(:, k);       
        rbm_aux;
        fitness(1, k) = err;
        fits(iter, k) = err;
    end
    
    fprintf('DE Iteration: %d\n', iter);
    
    fprintf('Fitness BEFORE iteration: %d\n', iter);
    disp(fits);
    
    for k=1:populationSize
        randomIndexes = zeros(1, 3);
        count = 1;
        while count <= 3
            randomIndex = round(1 + (populationSize - 1) * rand);
            if any(randomIndex==randomIndexes) == 0 && randomIndex ~= k
                randomIndexes(1, count) = randomIndex;
                count = count + 1;
            end
        end
        
        xk = population(:, k);
        xt = population(:, randomIndexes(1, 1));
        xr = population(:, randomIndexes(1, 2));
        xs = population(:, randomIndexes(1, 3));
        
        xoff(:, k) = xt + F * (xr - xs);
        
        for i=1:dimension
           if rand <= Cr
               xoff(i, k) = xk(i, 1);
           end
        end
        
        particle = xoff(:, k);       
        rbm_aux;
        fitnessXoff = err;       
        
        if fitnessXoff < fitness(1, k);
            replacementIndexes(1, k) = 1;
        end
    end
    
    for k=1:populationSize
        if replacementIndexes(1, k) == 1
            population(:, k) = xoff(:, k);
        end
    end
    
end
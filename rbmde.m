populationSize = 50;
dimension = (numdims * numhid) + numdims + numhid;
iterMax = 30;
F = 0.5;
Cr = 0.9;

population = 0.1*randn(dimension, populationSize);
population(:, 1) = [visbiases hidrecbiases reshape(vishid,numdims*numhid,1)'];
for i=1+1:populationSize
   population(:, i) = [visbiases+0.01*randn(1, numdims) hidrecbiases+0.01*randn(1, numhid) reshape(vishid,numdims*numhid,1)'+0.01*randn(1, numdims*numhid)]; 
end
xoff = zeros(dimension, populationSize);
replacementIndexes = zeros(1, populationSize);
fitness = zeros(1, populationSize);
fitnessOff = zeros(1, populationSize);

fits = zeros(iterMax+1, populationSize);

for k=1:populationSize        
    particle = population(:, k);       
    rbm_aux;
    fitness(1, k) = err;
    fits(1, k) = err;
end

disp(fits(1,1:10));
disp(fits(1,11:20));
disp(fits(1,21:30));
disp(fits(1,31:40));
disp(fits(1,41:50));

for iter=1:iterMax        
        
    fprintf('DE Iteration: %d\n', iter);
    
    %fprintf('Fitness BEFORE iteration: %d\n', iter);
    %disp(fits);
    
    replacementIndexes = zeros(1, populationSize);
    
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
        fitnessOff(1, k) = err;       
        
        if fitnessOff(1, k) < fits(iter, k);
            replacementIndexes(1, k) = 1;
        end
    end
    
    for k=1:populationSize
        if replacementIndexes(1, k) == 1
            population(:, k) = xoff(:, k);
            fits(iter+1, k) = fitnessOff(1, k);                       
        else
            fits(iter+1, k) = fits(iter, k);
        end
    end    
    
    disp(fits(iter,1:10));
    disp(fits(iter,11:20));
    disp(fits(iter,21:30));
    disp(fits(iter,31:40));
    disp(fits(iter,41:50));
    
    
end
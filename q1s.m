%Assignment #3

%population is represented by matrix with 50 rows and 3 columns
%Each row is a chromosome, with:
   %    col1=Kp (in 2,18)
   %    col2=Ti (in 1.05, 9.42)
   %    col3=Td (in 0.26, 2.37)
   
%generate 50 chromosomes in this range

GENERATIONS = 150;
POP_SIZE = 50;
PCROSSOVER=0.9;
PMUTATION=0.33;
%create column of random Kp values
pop = (18-2).*rand(1,POP_SIZE) + 2;
  
%add column of random Ti values
pop(2, :) = (9.42-1.05).*rand(1,POP_SIZE) + 1.05;

%add column of random Td values
pop(3, :) = (2.37-0.26).*rand(1,POP_SIZE) + 0.26;

%track best fitness in each generation for 150 gens
best_performance = zeros(1, GENERATIONS);
gen_best_ISE = zeros(1, GENERATIONS);
gen_best_tr = zeros(1, GENERATIONS);
gen_best_ts = zeros(1, GENERATIONS);
gen_best_mp = zeros(1, GENERATIONS);
for gen = 1:GENERATIONS+1

    %calculate performance data
    fit = zeros(1, POP_SIZE);
    best_fitness_1 = 0;
    best_chromo_1 = zeros(3, 1);
    best_fitness_2 = 0;
    best_chromo_2 = zeros(3, 1);
    bISE = 0;
    btr = 0;
    bts = 0;
    bmp = 0;
    for chromo = 1:POP_SIZE
        [ISE,t_r,t_s,M_p] = Q2_perfFCN(pop(1:3,chromo));
        %fprintf('result %d is:\n', chromo);
        %fprintf('%d,%d,%d,%d\n', ISE,t_r,t_s,M_p);
        %use performance data to calculate fitness
        
        fitval =fitness(ISE,t_r,t_s,M_p);
        fit(1, chromo) = fitval;%fitness values of every chrmomsome
        %keep track of 2 elite chromosomes
        if fitval > best_fitness_1
            best_fitness_2 = best_fitness_1;
            best_chromo_2 = best_chromo_1;
            best_fitness_1 = fitval;
            best_chromo_1 = pop(1:3,chromo);
            
            %save these for the analysis
            bISE = ISE;
            btr = t_r;
            bts = t_s;
            bmp = M_p;
            
        elseif fitval > best_fitness_2
            best_fitness_2 = fitval;
            best_chromo_2 = pop(1:3,chromo);
         end
    end

    %record best fitness for this generation
    best_performance(1, gen) = best_fitness_1;
    
    gen_best_ISE(1, gen) = bISE;
    gen_best_tr(1, gen) = btr;
    gen_best_ts(1, gen) = bts;
    gen_best_mp(1, gen) = bmp;
    
    %FPS
    prop_fit = fit/sum(fit)*POP_SIZE;
    count = round(prop_fit);
    tot = sum(count);
    %this is not always exact, adjust to 50 by 
    %adding the best or removing the worst
    if tot<POP_SIZE%add best 
        [val ind] = max(prop_fit);
        count(ind) = count(ind) + POP_SIZE-tot;
    end
    if tot>POP_SIZE%remove worst
        %removing worst might be causing premature
        %convergence, I will remove a random one
        %elitism will save the best anyway later on
        for c = 1:(tot-POP_SIZE) 
            %[val ind] = min(prop_fit(find(count)));
            %count(ind) = count(ind)-1;
            rem = find(count);
            count(rem(1)) = count(rem(1))-1;
        end
    end

    %now we have the location and values of the chromosomes 
    %we want. Construct the new population:

    copy_ind = 1;
    npop=zeros(3, POP_SIZE);
    for c = 1:POP_SIZE
        copy_num = count(c);
        if copy_num ~= 0
            npop(:,copy_ind:copy_ind+copy_num-1)=repmat(pop(:, c), 1,copy_num); 
        end
        copy_ind = copy_ind + copy_num;
    end

    %randomly scramble and then neighbours will mate
    npop = npop(:, randperm(POP_SIZE));

    %jump through in steps of two, apply crossover to neighbours
    for c = 1:2:POP_SIZE-1
       if (rand(1) <= PCROSSOVER)
           %apply crossover
           a  = 0.5;
           gene = randi([1 3], 1, 1);
           saved = npop(gene,c);
           npop(gene, c) = a*npop(gene,c) + (1-a)*npop(gene, c+1);
           npop(gene, c+1) = (1-a)*saved + a*npop(gene, c+1);
       end
    end

    %mutation
    for c = 1:POP_SIZE
        %check each gene individually
        %these are separated as the ranges for the genes are
        %different so the standard deviation should be different
        %so mutation can have similar effect on all genes
        
        if (rand(1) <= PMUTATION)
            %mutate
            npop(1,c) = npop(1,c) + normrnd(0, 1, 1, 1);
        end
        if (rand(1) <= PMUTATION)
            %mutate
            npop(2,c) = npop(2,c) + normrnd(0, 0.5, 1, 1);
        end
        if (rand(1) <= PMUTATION)
            %mutate
            npop(3,c) = npop(3,c) + normrnd(0, 0.125, 1, 1);
        end
    end

    %elitism survival strategy: make sure the best 2 chromosomes
    %are still there. If not, put them in a random place
    %I could copy into the worst place, but that seems
    %like the GENITOR srategy which from the notes may lead to
    %premature convergence
    if ~any(min(ismember(npop(1:3,:), best_chromo_1)))
        %it has been scrambled, first location is good as any
        npop(:, 1) = best_chromo_1;
    else
    end
    if ~any(min(ismember(npop(1:3,:), best_chromo_2)))
        npop(:, 2) = best_chromo_2;
    else
    end

    %next generation has been created
    %copy to old
    pop = npop;
    
    %Prints out information about each generation
    fprintf('generation %d:\n', gen);
    pop
end

%plot fitness data
plot(best_performance);
title('Chromosome Fitness');
xlabel('Generation');
ylabel('Fitness of Best Solution');

clc;
clear;
close all;

% % Problem Definition % %

% Neighborhood change from global to local.

CostFunction = @CamelBackFunction; % Cost function.
nVar = 2; % Number of unknown variables.
varSize = [1 nVar]; % Size of each solution.
varMin = -5;
varMax = 5; % Min and Max for x and y (decision variables).

% % Parameters of PSO % %
maxIt = 100; % Number of iterations (stop condition).
nPop = 50; % Size of swarm.
neighborSize = 10; % Size of neighborhood
w = 1; % Inertia coefficent.
c1 = 2; % Personal accel. coefficent.
c2 = 2; % Global accel. coefficent.

% % Initialization % %
% Particle template.
empty_particle.Position = [];
empty_particle.Velocity = [];
empty_particle.Cost = [];
empty_particle.Best.Position = [];
empty_particle.Best.Cost = [];

% Create Population Array
particle = repmat(empty_particle, nPop, 1);

% Initialize local best
LocalBest.Cost = inf(neighborSize,1); % Set to positive infinity for minimization.
LocalBest.Position = zeros(neighborSize,2);

BestCosts = [];
BestCosts = zeros(maxIt,1);

% Initalize Population Members
for i=1:nPop
  % Generate random solution for each particle
  particle(i).Position = unifrnd(varMin, varMax, varSize);
  
  % Initalize Velocity
  particle(i).Velocity = zeros(varSize);
  
  % Evaluation of cost
  particle(i).Cost = CostFunction(particle(i).Position);
  
  particle(i).Best.Position = particle(i).Position;
  particle(i).Best.Cost = particle(i).Cost;
  
  % Update Local Neighborhood Best
   if particle(i).Best.Cost < LocalBest.Cost(floor(i/10) + 1)
    LocalBest.Cost(floor(i/10) + 1) = particle(i).Best.Cost;
    LocalBest.Position(floor(i/10) + 1, 1) = particle(i).Best.Position(1);
    LocalBest.Position(floor(i/10) + 1, 2) = particle(i).Best.Position(2);
  end

end

% % Main Loop PSO % %
for it=1:maxIt
  for i=1:nPop
    % Velocity Equation
    r1 = rand(varSize);
    r2 = rand(varSize);
    LocalBestPosition = [LocalBest.Position(floor(i/10)+1,1)...
    LocalBest.Position(floor(i/10)+1,2)];
    particle(i).Velocity = w * particle(i).Velocity ...
    + c1 * r1.*(particle(i).Best.Position - particle(i).Position) ...
    + c2 * r2.*(LocalBestPosition - particle(i).Position);
    
    % Update Position
    particle(i).Position = particle(i).Position + particle(i).Velocity;
    
    % Calculate Cost
    particle(i).Cost = CostFunction(particle(i).Position);
    
    if particle(i).Cost < particle(i).Best.Cost
      particle(i).Best.Position = particle(i).Position;
      particle(i).Best.Cost = particle(i).Cost;
    end
    
    % Update Local Neighborhood Best
    if particle(i).Best.Cost < LocalBest.Cost(floor(i/10) + 1)
      LocalBest.Cost(floor(i/10) + 1) = particle(i).Best.Cost;
      LocalBest.Position(floor(i/10) + 1, 1) = particle(i).Best.Position(1);
      LocalBest.Position(floor(i/10) + 1, 2) = particle(i).Best.Position(2);
    end
  
  end
  % Store Best Cost Values
  BestCosts(it) = min(LocalBest.Cost);
end

%% Results
figure;
plot(BestCosts, 'LineWidth', 2);
title("Best Cost vs. Interation Neighborhood PSO")
xlabel('Iteration');
ylabel('Best Cost');
grid on;
clc;
clear;
close all;

% % Problem Definition % %

% Convergence PSO
% Set w = 0.792; c1 = c2 = 1.944

CostFunction = @CamelBackFunction; % Cost function.
nVar = 2; % Number of unknown variables.
varSize = [1 nVar]; % Size of each solution.
varMin = -5;
varMax = 5; % Min and Max for x and y (decision variables).

% % Parameters of PSO % %
maxIt = 100; % Number of iterations (stop condition).
nPop = 50; % Size of swarm.
w = 0.792; % Inertia coefficent.
c1 = 1.944; % Personal accel. coefficent.
c2 = 1.944; % Global accel. coefficent.

% % Initialization % %
% Particle template.
empty_particle.Position = [];
empty_particle.Velocity = [];
empty_particle.Cost = [];
empty_particle.Best.Position = [];
empty_particle.Best.Cost = [];

% Create Population Array
particle = repmat(empty_particle, nPop, 1);

% Initialize global best
GlobalBest.Cost = inf; % Set to positive infinity for minimization.

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
  
  % Update Global Best
  if particle(i).Best.Cost < GlobalBest.Cost
    GlobalBest.Cost = particle(i).Best.Cost;
    GlobalBest.Position = particle(i).Best.Position;
  end

end

% % Main Loop PSO % %
for it=1:maxIt
  for i=1:nPop
    % Velocity Equation
    r1 = rand(varSize);
    r2 = rand(varSize);
    particle(i).Velocity = w * particle(i).Velocity ...
    + c1 * r1.*(particle(i).Best.Position - particle(i).Position) ...
    + c2 * r2.*(GlobalBest.Position - particle(i).Position);
    
    % Update Position
    particle(i).Position = particle(i).Position + particle(i).Velocity;
    
    % Calculate Cost
    particle(i).Cost = CostFunction(particle(i).Position);
    
    if particle(i).Cost < particle(i).Best.Cost
      particle(i).Best.Position = particle(i).Position;
      particle(i).Best.Cost = particle(i).Cost;
    end
    
    % Update Global Best
    if particle(i).Best.Cost < GlobalBest.Cost
      GlobalBest.Cost = particle(i).Best.Cost;
      GlobalBest.Position = particle(i).Best.Position;
    end
  
  end
  % Store Best Cost Values
  BestCosts(it) = GlobalBest.Cost;
end

%% Results
figure;
plot(BestCosts, 'LineWidth', 2);
title("Best Cost vs. Interation Convergence PSO")
xlabel('Iteration');
ylabel('Best Cost');
grid on;
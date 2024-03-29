function create_train_file()
    percentage_training = 70;
    training_file = '54802.mat';

    trainFunctions1 = {'trainlm', 'traingd', 'trainrp'};
    performanceFunctions1 = {'mse'};
    activationsFunctions1 = {'hardlim', 'purelin', 'logsig', 'tansig'};
    goal = 1e-6;
    goalNEWRB = 0.01;
    epochs = 1000;
    validationChecks = epochs/2;
    learningRate = 0.5;
    numberLayers = 2;
    hiddenLayersSizes = [3, ceil(log2(29)), 29];
    number_characteristics = 29;

    handles = struct('percentage_training', percentage_training, 'training_file', training_file, 'characteristics', number_characteristics);

    [training_input, training_output, test_input, test_output] = prepareDataSets(handles);

    %%%%
    %%	Layrecnet
    %%%%
    networkName = 'Layer Recurrent';

    for i=1:length(trainFunctions1)

        trainFunction = char(trainFunctions1(i));

        for k=1:length(performanceFunctions1)

            performanceFunction = char(performanceFunctions1(k));

            for m=1:length(hiddenLayersSizes)

                currentSize = hiddenLayersSizes(m);

                network_data = struct('networkName', networkName, 'trainFunction', trainFunction, 'performanceFunction', performanceFunction, 'goal', goal, 'epochs', epochs, 'learningRate', learningRate, 'numberLayers', numberLayers, 'hiddenLayers', currentSize, 'trainingInput', training_input, 'trainingOutput', training_output, 'validationChecks', validationChecks);

                network = train_network(network_data);
                network = train(network, training_input, training_output, 'useGPU', 'yes');

                %Save trained network
                network_name = strcat('trainedNetworks/net_', networkName, '_', trainFunction, '_', performanceFunction, '_',num2str(currentSize), '.mat');
                save(network_name, 'network');
            end
        end
    end

    %%%%
    %%	Feedforward
    %%%%
    networkName = 'FeedForward';

    for i=1:length(trainFunctions1)

        trainFunction = char(trainFunctions1(i));

        for k=1:length(performanceFunctions1)

            performanceFunction = char(performanceFunctions1(k));

            for m=1:length(hiddenLayersSizes)

                currentSize = hiddenLayersSizes(m);

                network_data = struct('networkName', networkName, 'trainFunction', trainFunction, 'performanceFunction', performanceFunction, 'goal', goal, 'epochs', epochs, 'learningRate', learningRate, 'numberLayers', numberLayers, 'hiddenLayers', currentSize, 'trainingInput', training_input, 'trainingOutput', training_output, 'validationChecks', validationChecks);

                network = train_network(network_data);
                network = train(network, training_input, training_output, 'useGPU', 'yes');

                %Save trained network
                network_name = strcat('trainedNetworks/net_', networkName, '_', trainFunction, '_', performanceFunction, '_',num2str(currentSize), '.mat');
                save(network_name, 'network');
            end
        end
    end

    %%%%
    %%	Newrb
    %%%%
    networkName = 'Radial Basis Function';
    for m=1:length(hiddenLayersSizes)

        currentSize = hiddenLayersSizes(m);

        network = newrb(training_input, training_output, goalNEWRB, 1.0, currentSize, 1);
        network_name = strcat('trainedNetworks/net_', networkName, '_',num2str(currentSize), '.mat');
        save(network_name, 'network');
    end
end
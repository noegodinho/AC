function [ictalPositives, ictalNegatives, nIctalPositives, nIctalNegatives, preIctalPositives, preIctalNegatives, invalidData, expectedPositives, expectedNegatives] = interpretResults(testOutput, results)
    [~, numberCols] = size(results);    
    
    ictalPositives = 0;
    ictalNegatives = 0;
    
    nIctalPositives = 0;
    nIctalNegatives = 0;
    
    preIctalPositives = 0;
    preIctalNegatives = 0;
    
    invalidData = 0;
    expectedPositives = 0;
    expectedNegatives = 0;
    
    for i=1:numberCols
       
        currentCase = results(1:3,i);
        currentAnswer = testOutput(1:3,i);
        
        %Check if data is invalid or not
        if(sum(currentCase) == 0 || sum(currentCase) == 2 || sum(currentCase) == 3)
            %[0,0,0] / [1,1,0],[1,0,1],[0,1,1] / [1,1,1]
            invalidData = invalidData + 1;
        
        elseif(currentCase(1) == 1)
            %[1,0,0] Non-ictal
            expectedNegatives = expectedNegatives + 1;
            
        else
            %[0,1,0) || [0,0,1] Pre-Ictal or Ictal
            expectedPositives = expectedPositives + 1;            
        end
        
        if(currentCase(1) == 0 && currentCase(2) == 0 && currentCase(3) == 1) %Ictal
            if(currentAnswer(1) == 0 && currentAnswer(2) == 0 && currentAnswer(3) == 1)
                ictalPositives = ictalPositives + 1;
                
            else
                ictalNegatives = ictalNegatives + 1;
                
            end
            
        elseif(currentCase(1) == 0 && currentCase(2) == 1 && currentCase(3) == 0) %Pre-Ictal
            if(currentAnswer(1) == 0 && currentAnswer(2) == 1 && currentAnswer(3) == 0)
                preIctalPositives = preIctalPositives + 1;
                
            else
                preIctalNegatives = preIctalNegatives + 1;
                
            end  
        
        elseif(currentCase(1) == 1 && currentCase(2) == 0 && currentCase(3) == 0) %Non-Ictal
            if(currentAnswer(1) == 1 && currentAnswer(2) == 0 && currentAnswer(3) == 0)
                nIctalPositives = nIctalPositives + 1;
                
            else
                nIctalNegatives = nIctalNegatives + 1;
                
            end  
            
        end
    end
    
    preIctalPositives = ictalPositives;
    preIctalNegatives = ictalNegatives;
end
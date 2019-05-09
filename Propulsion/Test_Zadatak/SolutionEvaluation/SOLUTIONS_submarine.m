clear all

file_name = 'Solution_inputs.xlsx';

[Vload, MaxDepth, velocityMaxSpeed, kmMaxRange,...
CombTempFlagRange, TurbTempFlagRange, SaturatedFlagRange, deadFlagRange, evapErosionFlagRange, evapSuperFlagRange, pumpSpeedExceedFlagRange,...
CombTempFlagSpeed, TurbTempFlagSpeed, SaturatedFlagSpeed, deadFlagSpeed, evapErosionFlagSpeed, evapSuperFlagSpeed, pumpSpeedExceedFlagSpeed,...
CombTempFlagDepth, TurbTempFlagDepth, SaturatedFlagDepth, deadFlagDepth, evapErosionFlagDepth, evapSuperFlagDepth, pumpSpeedExceedFlagDepth] =...
SolutionEval(file_name)

rezultati = table(Vload, MaxDepth, velocityMaxSpeed, kmMaxRange,...
CombTempFlagRange, TurbTempFlagRange, SaturatedFlagRange, deadFlagRange, evapErosionFlagRange, evapSuperFlagRange, pumpSpeedExceedFlagRange,...
CombTempFlagSpeed, TurbTempFlagSpeed, SaturatedFlagSpeed, deadFlagSpeed, evapErosionFlagSpeed, evapSuperFlagSpeed, pumpSpeedExceedFlagSpeed,...
CombTempFlagDepth, TurbTempFlagDepth, SaturatedFlagDepth, deadFlagDepth, evapErosionFlagDepth, evapSuperFlagDepth, pumpSpeedExceedFlagDepth);
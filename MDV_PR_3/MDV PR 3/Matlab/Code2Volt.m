% func t i on [ v o l t a g e ] = Code2Volt (Code )
%
% f i l ename : Bin2Volt .m
% author : Ihr_Name
% o r g ani s a t i on : TU Be r l in
% p r o j e c t : MDV PR
% dat e : Tag_der_Bearbeitung
%
% d e s c r i p t i o n : r e chne t d i e vom ADU ausgegebenen Zahlencodes
% in Spannungen ( Einh e i t : V) um
% input : Code : vom ADU ausgegebene Zahlencodes
% output : [ v o l a t g e ] : b e r e c hne t e Spannungen [V]


function [voltage] = Code2Volt(Code);

n = 7/511;

voltage = Code * n;
return;
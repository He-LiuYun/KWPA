function [residuals,jaco] = residual_cal(posi_1,posi_2,d)
%������ӵĲв����ڵ�֮��Ĳв���ſɱȾ���
%ע�⣺�����posi��Ҫ����mΪ��λ
H = zeros(1,6);
r = sqrt((posi_1 - posi_2)' * (posi_1 - posi_2));%%ŷ�Ͼ���
H(1,1) =   (posi_1(1,1) - posi_2(1,1))/r;
H(1,2) =   (posi_1(2,1) - posi_2(2,1))/r;
H(1,3) =   (posi_1(3,1) - posi_2(3,1))/r;
H(1,4) = - (posi_1(1,1) - posi_2(1,1))/r;
H(1,5) = - (posi_1(2,1) - posi_2(2,1))/r;
H(1,6) = - (posi_1(3,1) - posi_2(3,1))/r;%%���ݹ�ʽ�������ſɱȾ���H�ĸ���Ԫ�أ�������洢��H��

residuals = r - d;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
residuals = 1/sqrt(0.09) * residuals;      %�����������ƽ����

jaco = 1/sqrt(0.09) * H;

end
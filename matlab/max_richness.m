%little script that shows how L and R play off one another
%uses an approximatino of the sum as an integral for larger R and alpha

clear; close all;
figure(1)

% do this for real for Hosmane (L=1e7) and compare to integral approximation

R=1e7;
C=1e7;

r=1:R;

for j=1:20;
    al(j)=1.1*j/8;

    a=r.^(-al(j));
    a=round(C*a./sum(a));    
    maxr_Hos(j)=length(a(a>0));
    
    psi=0.5*(1-R^(1-al(j)))/(C*(al(j)-1));
    mr=exp(log(psi)/-al(j)); %approximate max richness

    if mr>C
        maxr_approx(j)=C;
    else
        maxr_approx(j)=mr;
    end
end

subplot(121)
plot(log10(maxr_Hos),al,'k','LineWidth',2)
hold on
plot(log10(maxr_approx),al,'--r','LineWidth',2)
legend('actual','approx')
xlabel('maximum possible richness')
ylabel('pwl parameter, \alpha')
xlim([3,10])
ylim([0,3])

% do this approximately for DNA because L=1e9 and it crashes the computer
phi=1e9; R=1e9;
for j=1:20;
    al(j)=1.1*j/7;
    psi=0.5*(1-R^(1-al(j)))/(phi*(al(j)-1));
    mr=exp(log(psi)/-al(j));%approximate max richness
    
    if mr>phi
        maxr(j)=phi;
    else
        maxr(j)=mr;
    end
end

subplot(122)
plot(log10(maxr),al,'--r','LineWidth',2)
xlabel('maximum possible richness')
%ylabel('pwl parameter, \alpha')
xlim([3,10])
ylim([0,3])

%print the figure
w=6;
h=3;
u='inches';
pp=0.01;

set(gcf,'Units',u);
screenpos = get(gcf,'Position');

set(gcf,...
  'Position',[screenpos(1:2) w h],...
  'PaperUnits',u,...
  'PaperPosition',[pp*w pp*h w h],...
  'PaperSize',[w*(1+2*pp) h*(1+2*pp)]);

tightfig;
print('max_richness_approx','-dpng','-r600') 

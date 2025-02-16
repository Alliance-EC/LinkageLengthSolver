function leg_show(theta1,theta4,L1,L2,L3,L4,L5,type)
    close all;
    if abs(type - 3.0) < 0.01
        A=[-L5/2, 0];
        E=[L5/2, 0];
        B = A + [L1*cos(theta1), L1*sin(theta1)];
        D = E + [L4*cos(theta4), L4*sin(theta4)];
        % 使用几何关系解算其他连杆位置
        A0=2*L2*(D(1)-B(1));
        B0=2*L2*(D(2)-B(2));
        C0=L2^2+(D(1)-B(1))^2+(D(2)-B(2))^2-L3^2;
        discriminant = A0^2 + B0^2 - C0^2;
        A1=2*L3*(B(1)-D(1));
        B1=2*L3*(B(2)-D(2));
        C1=L3^2+(B(1)-D(1))^2+(B(2)-D(2))^2-L2^2;
        discriminant1 = A1^2 + B1^2 - C1^2;
        if discriminant < 0 ||discriminant1<0
            disp("跳过非物理解");
            return;
        end
        theta2=2*atan2((B0 + sqrt(A0 ^ 2 + B0 ^ 2 - C0 ^ 2)), (A0 + C0));
        C(1)=L2*cos(theta2)+B(1);
        C(2)=L2*sin(theta2)+B(2);
        cha1=((D(1)-C(1))*(E(2)-C(2))-(D(2)-C(2))*(E(1)-C(1)));
        cha2=((B(1)-A(1))*(C(2)-A(2))-(B(2)-A(2))*(C(1)-A(1)));
        % if cha1<0||cha2>0||(A(2)>((D(2)-C(2))/(D(1)-C(1)))*(A(1)-C(1))+C(2))&&((D(2)-C(2))/(D(1)-C(1))<0)
        %     disp("舍去反关节解");
        %     return;
        % end
        F(1)=C(1)*11/6-5*B(1)/6;
        F(2)=C(2)*11/6-5*B(2)/6;
        plot([A(1), B(1), C(1), D(1),E(1)], ...
             [A(2), B(2), C(2), D(2),E(2)], 'o-');
        l0=sqrt(F(1)^2+F(2)^2);
        phi0=pi/2-atan2(F(2),F(1));
        disp(l0);
        disp(phi0);
        hold on;
        plot(F(1), F(2), 'ro', 'MarkerSize', 8);
        hold off;
        axis equal;
        axis([-300, 300, -300, 300]);
        grid on;
        drawnow;
    % 传统五连杆
    elseif abs(type - 2) < 0.01
        A=[-L5/2, 0];
        E=[L5/2, 0];
        B = A + [L1*cos(theta1), L1*sin(theta1)];
        D = E + [L4*cos(theta4), L4*sin(theta4)];
        % 使用几何关系解算其他连杆位置
        A0=2*L2*(D(1)-B(1));
        B0=2*L2*(D(2)-B(2));
        C0=L2^2+(D(1)-B(1))^2+(D(2)-B(2))^2-L3^2;
        discriminant = A0^2 + B0^2 - C0^2;
         A1=2*L3*(B(1)-D(1));
        B1=2*L3*(B(2)-D(2));
        C1=L3^2+(B(1)-D(1))^2+(B(2)-D(2))^2-L2^2;
        discriminant1 = A1^2 + B1^2 - C1^2;
        if discriminant < 0 ||discriminant1<0
            disp("跳过非物理解");
            return;
        end
        theta2=2*atan2((B0 + sqrt(A0 ^ 2 + B0 ^ 2 - C0 ^ 2)), (A0 + C0));
        C(1)=L2*cos(theta2)+B(1);
        C(2)=L2*sin(theta2)+B(2);
        cha1=((D(1)-C(1))*(E(2)-C(2))-(D(2)-C(2))*(E(1)-C(1)));
        cha2=((B(1)-A(1))*(C(2)-A(2))-(B(2)-A(2))*(C(1)-A(1)));
        F(1)=C(1)*11/6-5*B(1)/6;
        F(2)=C(2)*11/6-5*B(2)/6;
        plot([A(1), B(1), C(1), D(1),E(1)], ...
             [A(2), B(2), C(2), D(2),E(2)], 'o-');
        hold on;
        hold off;
        axis equal;
        grid on;
        drawnow;
else 
   disp("type out of range");
end

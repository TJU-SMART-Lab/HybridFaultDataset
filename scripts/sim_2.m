total_xmv5 = 18.00:0.01:18.09;
Ts_save = 0.02;
I = eye(28);

for now_idv_0 = 1:20
    for now_idv_1 = 1:20
        if now_idv_0 == now_idv_1
            continue
        end
        
        for xmv5_idx = 1:10
            clear simout;
            clear xmv;
            clear result;

            this_idv = zeros(1, 28);
            this_xmv5 = total_xmv5(xmv5_idx);
            set_param('MultiLoop_mode3','SimulationCommand','update');
            set_param('MultiLoop_mode3','SimulationCommand','start');

            while get_param('MultiLoop_mode3', 'SimulationStatus') ~= "paused"
                pause(0.5);
            end

            this_idv = I(now_idv_0, :) + I(now_idv_1, :);

            set_param('MultiLoop_mode3','SimulationCommand','update');
            set_param('MultiLoop_mode3','SimulationCommand','continue');

            while get_param('MultiLoop_mode3', 'SimulationStatus') ~= "stopped"
                pause(0.5);
            end

            result = cat(2, simout(502:end,:), xmv(502:end,:));

            result(:, 53) = [];
            result(:, 50) = [];

            filename = strcat(num2str(now_idv_0), "_", num2str(now_idv_1), "_", sprintf("%.2f", this_xmv5), ".mat");
            save(filename, 'result');
        end
    end
end
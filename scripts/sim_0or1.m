total_xmv5 = 18.00:0.01:18.09;
Ts_save = 0.02;

for now_idv = 1:20
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

        if now_idv == 0
            this_idv = zeros(1, 28);
        else
            I = eye(28);
            this_idv = I(now_idv, :);
        end
        set_param('MultiLoop_mode3','SimulationCommand','update');
        set_param('MultiLoop_mode3','SimulationCommand','continue');

        while get_param('MultiLoop_mode3', 'SimulationStatus') ~= "stopped"
            pause(0.5);
        end

        if now_idv == 0
            result = cat(2, simout(2:end, :), xmv(2:end, :));
        else
            result = cat(2, simout(502:end,:), xmv(502:end,:));
        end
        result(:, 53) = [];
        result(:, 50) = [];

        filename = strcat(num2str(now_idv), "_", sprintf("%.2f", this_xmv5), ".mat");
        save(filename, 'result');
    end
end

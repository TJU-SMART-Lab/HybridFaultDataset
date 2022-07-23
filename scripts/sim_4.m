total_xmv5 = 18.00:0.01:18.09;
Ts_save = 0.02;
I = eye(28);

A = [];
for now_idv_0 = 1:20
    for now_idv_1 = 1:20
        for now_idv_2 = 1:20
            for now_idv_3 = 1:20
                if length(unique([now_idv_0, now_idv_1, now_idv_2, now_idv_3])) ~= 4
                    continue
                end

                current_idvs = strjoin(string(sort([now_idv_0, now_idv_1, now_idv_2, now_idv_3])));
                if any(strcmp(A(:), current_idvs))
                    continue
                end
                A = [A, current_idvs];

                for xmv5_idx = 1:10
                    clear simout;
                    clear xmv;
                    clear result;

                    this_idv = zeros(1, 28);
                    this_xmv5 = total_xmv5(xmv5_idx);

                    filename = strcat(num2str(now_idv_0), "_", num2str(now_idv_1), "_", num2str(now_idv_2), "_", num2str(now_idv_3), "_", sprintf("%.2f", this_xmv5), ".mat");
                    if isfile(filename)
                        continue
                    end

                    set_param('MultiLoop_mode3','SimulationCommand','update');
                    set_param('MultiLoop_mode3','SimulationCommand','start');

                    while get_param('MultiLoop_mode3', 'SimulationStatus') ~= "paused"
                        pause(0.5);
                    end

                    this_idv = I(now_idv_0, :) + I(now_idv_1, :) + I(now_idv_2, :) + I(now_idv_3, :);

                    set_param('MultiLoop_mode3','SimulationCommand','update');
                    set_param('MultiLoop_mode3','SimulationCommand','continue');

                    while get_param('MultiLoop_mode3', 'SimulationStatus') ~= "stopped"
                        pause(0.5);
                    end

                    result = cat(2, simout(502:end,:), xmv(502:end,:));

                    result(:, 53) = [];
                    result(:, 50) = [];

                    save(filename, 'result');
                end
            end
        end
    end
end
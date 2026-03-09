import os
from multiprocessing import Pool

def run_simulation(params):
    oecc_param, fault_param, recc_param = params
    # REMOVED the '&' so that the script waits for each simulation to finish
    command = f"./Fault_sim_start {oecc_param} {fault_param} {recc_param}"
    print(f"Simulation started: {command}")
    os.system(command)

if __name__ == '__main__':
    # Configurations for HSIAO, CHIPKILL scenarios, and SSC-DEC (Unity ECC)
    oecc = [1] # 0 : no-ecc, 1 : SEC (Hsiao)
    # fault = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] # SE_NE_NE=0, SE_SE_NE=1, SE_SE_SE=2, CHIPKILL_NE_NE=3, CHIPKILL_SE_NE=4, CHIPKILL_CHIPKILL_NE=5, DE_NE_NE=6, DE_DE_NE=7, DE_DE_DE=8, CHIPKILL_DE_NE=9
    fault = [3] # chip error만 측정
    recc = [1] # 0 : AMD Chipkill, 1 : SSC-DEC, 2 : NO Rank-level ECC

    tasks = [(o, f, r) for o in oecc for f in fault for r in recc]

    print(f"Starting {len(tasks)} parallel tasks...")
    # Pool will use your CPU cores to run these in parallel but will WAIT until finished
    with Pool() as p:
        p.map(run_simulation, tasks)
    
    print("All tasks completed successfully.")
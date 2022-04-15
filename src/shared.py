import multiprocessing

manager = multiprocessing.Manager()
sarif_outputs = manager.dict()
tasks_started = multiprocessing.Value('L', 0)
tasks_completed = multiprocessing.Value('L', 0)
total_time = multiprocessing.Value('f', 0.0)

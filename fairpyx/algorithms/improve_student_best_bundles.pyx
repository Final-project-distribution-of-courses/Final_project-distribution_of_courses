# improve_student_best_bundles.pyx

from itertools import combinations, product

from fairpyx import Instance

def student_best_bundles(dict prices, instance: Instance, dict initial_budgets):
    cdef dict all_combinations = {student: [] for student in instance.agents}
    cdef list combinations_courses_list
    cdef int capacity
    cdef double max_valuation
    cdef double price_combination
    cdef double current_valuation
    cdef list valid_allocations = []

    for student in instance.agents:
        combinations_courses_list = []
        capacity = instance.agent_capacity(student)
        for r in range(1, capacity + 1):
            combinations_courses_list.extend(combinations(instance.items, r))

        max_valuation = -1
        for combination in combinations_courses_list:
            price_combination = sum(prices[course] for course in combination)
            if price_combination <= initial_budgets[student]:
                current_valuation = instance.agent_bundle_value(student, combination)
                if current_valuation >= max_valuation:
                    if current_valuation > max_valuation:
                        all_combinations[student] = []
                    max_valuation = current_valuation
                    all_combinations[student].append(list(combination))

        if not all_combinations[student]:
            all_combinations[student].append(())

    all_combinations_list = list(product(*all_combinations.values()))

    cdef dict valid_allocation

    for allocation in all_combinations_list:
        valid_allocation = {}  # Initialize inside the loop
        for student, bundle in zip(instance.agents, allocation):
            if sum(prices[item] for item in bundle) <= initial_budgets[student]:
                valid_allocation[student] = list(bundle)
        if len(valid_allocation) == len(instance.agents):
            valid_allocations.append(valid_allocation)

    return valid_allocations

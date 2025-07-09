from datetime import datetime, timedelta
import os
import random
import json

def create_output_directory():
    """Create output directory if it doesn't exist"""
    try:
        if not os.path.exists('output'):
            os.makedirs('output')
            print("Created 'output/' directory")
        return True
    except Exception as e:
        print(f"Error creating output directory: {e}")
        return False

def generate_workers(num_workers=400):
    """Generate a dynamic list of workers"""
    workers = []
    try:
        for i in range(num_workers):
            worker = {
                'id': f'EMP{i+1:04d}',
                'name': f'Worker_{i+1}',
                'salary': random.uniform(5000, 35000),  # Random salary range
                'gender': random.choice(['Male', 'Female']),
                'employee_level': 'Unassigned'
            }
            workers.append(worker)
        return workers
    except Exception as e:
        print(f"Error generating workers: {e}")
        return []

def determine_employee_level(salary, gender):
    """Determine employee level based on conditions"""
    try:
        # Condition 1: A1 level
        if 10000 < salary < 20000:
            return "A1"
        # Condition 2: A5-F level  
        elif 7500 < salary < 30000 and gender.lower() == 'female':
            return "A5-F"
        else:
            return "Standard"
    except Exception as e:
        print(f"Error determining employee level: {e}")
        return "Error"

def generate_payment_date():
    """Generate a dynamic payment date (weekly payment dates)"""
    try:
        # Get current date
        current_date = datetime.now()
        
        # Find the most recent Friday (typical payday)
        days_since_friday = (current_date.weekday() - 4) % 7
        if days_since_friday == 0 and current_date.hour < 17:  # If it's Friday before 5 PM
            last_friday = current_date
        else:
            last_friday = current_date - timedelta(days=days_since_friday)
                
        return last_friday.strftime('%Y-%m-%d')
        
    except Exception as e:
        print(f"Error generating payment date: {e}")
        return datetime.now().strftime('%Y-%m-%d')

def generate_payment_slips(workers):
    """Generate payment slips for all workers"""
    payment_slips = []
    
    try:
        for worker in workers:
            # Determine employee level
            worker['employee_level'] = determine_employee_level(
                worker['salary'], 
                worker['gender']
            )
            
            # Generate dynamic payment date
            payment_date = generate_payment_date()
            
            # Create payment slip
            payment_slip = {
                'employee_id': worker['id'],
                'name': worker['name'],
                'salary': round(worker['salary'], 2),
                'gender': worker['gender'],
                'employee_level': worker['employee_level'],
                'payment_date': payment_date
            }
            
            payment_slips.append(payment_slip)
            
        return payment_slips
        
    except Exception as e:
        print(f"Error generating payment slips: {e}")
        return []

def main():
    """Main function to run the program"""
    try:
        print("Highridge Construction Company - Payment Slip Generator")
        print("="*60)
        
         # Create output directory
        if not create_output_directory():
            print("Failed to create output directory. Exiting.")
            return
        
        # Generate workers
        workers = generate_workers(400)
        print(f"Generated {len(workers)} workers successfully")
        
        # Generate payment slips
        payment_slips = generate_payment_slips(workers)
        print(f"Generated {len(payment_slips)} payment slips")
        
        # Display summary statistics
        a1_count = sum(1 for slip in payment_slips if slip['employee_level'] == 'A1')
        a5f_count = sum(1 for slip in payment_slips if slip['employee_level'] == 'A5-F')
        
        print(f"\nSummary:")
        print(f"A1 Level employees: {a1_count}")
        print(f"A5-F Level employees: {a5f_count}")
        
        # Save to file
        with open('output/payment_slips.json', 'w') as f:
            json.dump(payment_slips, f, indent=2)
        
        print("Payment slips saved to 'output/payment_slips.json'")
        
    except Exception as e:
        print(f"Program error: {e}")

if __name__ == "__main__":
    main()

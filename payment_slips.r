library(jsonlite)

create_output_directory <- function() {
  tryCatch({
    if (!dir.exists("output")) {
      dir.create("output")
      cat("Created 'output/' directory\n")
    }
    return(TRUE)
  }, error = function(e) {
    cat("Error creating output directory:", e$message, "\n")
    return(FALSE)
  })
}

generate_workers <- function(num_workers = 400) {
  tryCatch({
    workers <- data.frame(
      id = sprintf("EMP%04d", 1:num_workers),
      name = paste0("Worker_", 1:num_workers),
      salary = runif(num_workers, 5000, 35000),
      gender = sample(c("Male", "Female"), num_workers, replace = TRUE),
      employee_level = "Unassigned",
      stringsAsFactors = FALSE
    )
    return(workers)
  }, error = function(e) {
    cat("Error generating workers:", e$message, "\n")
    return(data.frame())
  })
}

determine_employee_level <- function(salary, gender) {
  tryCatch({
    if (salary > 10000 & salary < 20000) {
      return("A1")
    } else if (salary > 7500 & salary < 30000 & tolower(gender) == "female") {
      return("A5-F")
    } else {
      return("Standard")
    }
  }, error = function(e) {
    cat("Error determining employee level:", e$message, "\n")
    return("Error")
  })
}

generate_payment_date <- function() {
  tryCatch({
    # Get current date
    current_date <- Sys.Date()
    
    # Find the most recent Friday (typical payday)
    # weekdays() returns day names, we want Friday
    current_weekday <- as.POSIXlt(current_date)$wday  # 0=Sunday, 5=Friday
    
    # Calculate days since last Friday
    days_since_friday <- ifelse(current_weekday >= 5, 
                               current_weekday - 5, 
                               current_weekday + 2)
    
    last_friday <- current_date - days_since_friday
    
    return(as.character(last_friday))
    
  }, error = function(e) {
    cat("Error generating payment date:", e$message, "\n")
    return(as.character(Sys.Date()))
  })
}

generate_payment_slips <- function(workers) {
  tryCatch({
    payment_slips <- data.frame()
    
    for (i in 1:nrow(workers)) {
      worker <- workers[i, ]
      
      # Determine employee level
      employee_level <- determine_employee_level(worker$salary, worker$gender)
      
      # Generate dynamic payment date
      payment_date <- generate_payment_date()

      # Create payment slip
      payment_slip <- data.frame(
        employee_id = worker$id,
        name = worker$name,
        salary = round(worker$salary, 2),
        gender = worker$gender,
        employee_level = employee_level,
        payment_date = payment_date,
        stringsAsFactors = FALSE
      )
      
      payment_slips <- rbind(payment_slips, payment_slip)
    }
    
    return(payment_slips)
    
  }, error = function(e) {
    cat("Error generating payment slips:", e$message, "\n")
    return(data.frame())
  })
}

main <- function() {
  tryCatch({
    cat("Highridge Construction Company - Payment Slip Generator\n")
    cat(paste(rep("=", 60), collapse = ""), "\n")
    
    # Create output directory
    if (!create_output_directory()) {
      cat("Failed to create output directory. Exiting.\n")
      return()
    }

    # Generate workers
    workers <- generate_workers(400)
    cat("Generated", nrow(workers), "workers successfully\n")
    
    # Generate payment slips
    payment_slips <- generate_payment_slips(workers)
    cat("Generated", nrow(payment_slips), "payment slips\n")
    
    # Display summary statistics
    a1_count <- sum(payment_slips$employee_level == "A1")
    a5f_count <- sum(payment_slips$employee_level == "A5-F")
    
    cat("\nSummary:\n")
    cat("A1 Level employees:", a1_count, "\n")
    cat("A5-F Level employees:", a5f_count, "\n")
    
    # Save to file
    write_json(payment_slips, "output/payment_slips_r.json", pretty = TRUE)
    cat("Payment slips saved to 'output/payment_slips_r.json'\n")
    
  }, error = function(e) {
    cat("Program error:", e$message, "\n")
  })
}

# Run the main function
main()

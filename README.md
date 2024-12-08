# FuzzySystems

These are the projects implemented for the Fuzzy System Course in the Electrical and Computer Engineering Department at Aristotle University of Thessaloniki.

## Project Structure

Each project follows this structure:
- **`report/`**: Contains the project description and the report (in Greek).
- **`matlab/`**: Includes the MATLAB code for the project.
- **`Plots_part_X/`** (if applicable): Stores the plots generated for specific parts of the project.

---

## Projects Overview

### Project 1: Engine Control with Fuzzy Controllers
- Development of a fuzzy logic system to control engine parameters.
- Focused on designing fuzzy rules and membership functions for efficient engine management.

---

### Project 2: Car Control System with Obstacle Avoidance
- Implementation of a fuzzy rule-based system to guide a car towards its destination while avoiding obstacles.
- The system adjusts car movement dynamically based on sensory inputs.

---

### Project 3: Regression with Fuzzy TSK Models

#### Tasks:
1. **Data Preparation**:
   - Split data into `data_train`, `data_validation`, and `data_test`.
2. **Regression Model Training**:
   - Train fuzzy TSK regression models with various parameters.
   - Optimize models using the backpropagation algorithm.
3. **Evaluation Metrics**:
   - RMSE, \( R^2 \), NMSE, NDEI.
4. **Parameter Optimization**:
   - Employ **grid search** to identify the best parameters for the fuzzy TSK models.
5. **Feature Selection**:
   - Apply the **RELIEF algorithm** to identify optimal features for modeling.
6. **Subtractive Clustering**:
   - Use **grid search** and **5-fold cross-validation** to determine optimal parameters for subtractive clustering.
   - Perform **dimensionality reduction** based on subtractive clustering results.
7. **Performance Assessment**:
   - Evaluate the best model and visualize learning curves.

---

### Project 4: Classification with Fuzzy TSK Models

#### Tasks:
1. **Data Preparation**:
   - Split data into `data_train`, `data_validation`, and `data_test`.
2. **Classification Model Training**:
   - Train fuzzy TSK classification models with various parameters.
   - Optimize models using the backpropagation algorithm.
3. **Evaluation Metrics**:
   - Error matrix.
   - Overall accuracy.
   - Producer accuracy.
   - User accuracy.
   - Kappa statistic (\( K \)).
4. **Parameter Optimization**:
   - Employ **grid search** to identify the best parameters for the fuzzy TSK models.
5. **Feature Selection**:
   - Apply the **RELIEF algorithm** to identify the optimal features for classification.
6. **Subtractive Clustering**:
   - Use **grid search** and **5-fold cross-validation** to determine optimal parameters for subtractive clustering.
   - Perform **dimensionality reduction** based on subtractive clustering results.
7. **Performance Assessment**:
   - Evaluate the best classification model.
   - Plot learning curves for detailed analysis.

---

## Notes
- All project descriptions and reports are written in Greek.
- MATLAB was used extensively for all implementations, including system modeling, optimization, and visualization.

---

Feel free to explore the individual project directories for detailed reports and source code!

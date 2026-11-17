<%@ page contentType="text/html;charset=UTF-8" %>
<%
    int activeStep = 1;
    try {
        if (request.getParameter("step") != null) {
            activeStep = Integer.parseInt(request.getParameter("step"));
        } else if (request.getAttribute("activeStep") != null) {
            activeStep = (Integer) request.getAttribute("activeStep");
        }
    } catch (Exception ignored) {}
%>

<style>
/* Self-contained Stepper Styles */
.booking-stepper-wrap {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 14px;
    padding: 16px 24px;
    margin-bottom: 22px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05), 0 4px 12px rgba(0, 0, 0, 0.03);
}

.booking-stepper {
    display: flex;
    align-items: center;
    justify-content: space-between;
    position: relative;
    overflow-x: auto;
    padding: 4px 0;
    gap: 8px;
}

.stepper-step {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-shrink: 0;
    text-decoration: none;
    cursor: default;
}

.stepper-step .step-circle {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.88rem;
    font-weight: 700;
    background: #f1f5f9;
    color: #64748b;
    border: 2px solid #e2e8f0;
    transition: all 0.2s ease;
}

.stepper-step .step-label {
    display: flex;
    flex-direction: column;
}

.stepper-step .step-num {
    font-size: 0.68rem;
    text-transform: uppercase;
    letter-spacing: 0.06em;
    font-weight: 700;
    color: #94a3b8;
    line-height: 1.2;
}

.stepper-step .step-title {
    font-size: 0.86rem;
    font-weight: 600;
    color: #64748b;
    white-space: nowrap;
    line-height: 1.3;
}

/* Stepper States */
.stepper-step.completed .step-circle {
    background: #ecfdf5;
    color: #059669;
    border-color: #10b981;
}

.stepper-step.completed .step-title {
    color: #1e293b;
    font-weight: 600;
}

.stepper-step.active .step-circle {
    background: #4f46e5;
    color: #ffffff;
    border-color: #4f46e5;
    box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.2);
}

.stepper-step.active .step-num {
    color: #4f46e5;
}

.stepper-step.active .step-title {
    color: #1e1b4b;
    font-weight: 700;
}

.stepper-divider {
    flex: 1;
    height: 2px;
    background: #e2e8f0;
    min-width: 20px;
}

.stepper-divider.completed {
    background: #10b981;
}

@media (max-width: 768px) {
    .stepper-step .step-label {
        display: none;
    }
}
</style>

<div class="booking-stepper-wrap">
    <div class="booking-stepper">
        <!-- Step 1: Choose Date -->
        <div class="stepper-step <%= activeStep > 1 ? "completed" : (activeStep == 1 ? "active" : "") %>">
            <div class="step-circle">
                <%= activeStep > 1 ? "<i class='fa-solid fa-check'></i>" : "1" %>
            </div>
            <div class="step-label">
                <span class="step-num">Step 1</span>
                <span class="step-title">Choose Date</span>
            </div>
        </div>

        <div class="stepper-divider <%= activeStep > 1 ? "completed" : "" %>"></div>

        <!-- Step 2: Select Vendor -->
        <div class="stepper-step <%= activeStep > 2 ? "completed" : (activeStep == 2 ? "active" : "") %>">
            <div class="step-circle">
                <%= activeStep > 2 ? "<i class='fa-solid fa-check'></i>" : "2" %>
            </div>
            <div class="step-label">
                <span class="step-num">Step 2</span>
                <span class="step-title">Select Vendor</span>
            </div>
        </div>

        <div class="stepper-divider <%= activeStep > 2 ? "completed" : "" %>"></div>

        <!-- Step 3: Choose Items -->
        <div class="stepper-step <%= activeStep > 3 ? "completed" : (activeStep == 3 ? "active" : "") %>">
            <div class="step-circle">
                <%= activeStep > 3 ? "<i class='fa-solid fa-check'></i>" : "3" %>
            </div>
            <div class="step-label">
                <span class="step-num">Step 3</span>
                <span class="step-title">Choose Items</span>
            </div>
        </div>

        <div class="stepper-divider <%= activeStep > 3 ? "completed" : "" %>"></div>

        <!-- Step 4: Review Price -->
        <div class="stepper-step <%= activeStep > 4 ? "completed" : (activeStep == 4 ? "active" : "") %>">
            <div class="step-circle">
                <%= activeStep > 4 ? "<i class='fa-solid fa-check'></i>" : "4" %>
            </div>
            <div class="step-label">
                <span class="step-num">Step 4</span>
                <span class="step-title">Review Price</span>
            </div>
        </div>

        <div class="stepper-divider <%= activeStep > 4 ? "completed" : "" %>"></div>

        <!-- Step 5: Confirm Booking -->
        <div class="stepper-step <%= activeStep > 5 ? "completed" : (activeStep == 5 ? "active" : "") %>">
            <div class="step-circle">
                <%= activeStep > 5 ? "<i class='fa-solid fa-check'></i>" : "5" %>
            </div>
            <div class="step-label">
                <span class="step-num">Step 5</span>
                <span class="step-title">Confirm Booking</span>
            </div>
        </div>

        <div class="stepper-divider <%= activeStep >= 6 ? "completed" : "" %>"></div>

        <!-- Step 6: View Receipt -->
        <div class="stepper-step <%= activeStep == 6 ? "active completed" : "" %>">
            <div class="step-circle">
                <%= activeStep >= 6 ? "<i class='fa-solid fa-file-invoice'></i>" : "6" %>
            </div>
            <div class="step-label">
                <span class="step-num">Step 6</span>
                <span class="step-title">View Receipt</span>
            </div>
        </div>
    </div>
</div>

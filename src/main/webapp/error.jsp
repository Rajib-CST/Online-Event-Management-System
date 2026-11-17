<%@ page contentType="text/html; charset=UTF-8" isErrorPage="true" %>
<%
    Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
    String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri");
    Throwable ex = (Throwable) request.getAttribute("javax.servlet.error.exception");
    String customMessage = (String) request.getAttribute("errorMessage");

    if (ex != null) {
        System.err.println("Unhandled error at [" + requestUri + "]:");
        ex.printStackTrace();
    }

    int code = (statusCode != null) ? statusCode : 500;
    String heading;
    String message;

    switch (code) {
        case 404:
            heading = "404";
            message = "The page you're looking for doesn't exist or may have been relocated.";
            break;
        case 403:
            heading = "403";
            message = "You don't have authorization to access this page. Please log in with the appropriate account privileges.";
            break;
        case 400:
            heading = "400";
            message = "The request could not be processed due to invalid parameters. Please try again.";
            break;
        default:
            heading = "500";
            message = "An unexpected server issue occurred. Please try again shortly.";
    }
    if (customMessage != null) message = customMessage;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error <%= heading %> | EventArrange</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Outfit:wght@400;500;600;700;800;900&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
<div class="container" style="display:flex;align-items:center;justify-content:center;min-height:90vh;">
    <div class="error-box card">
        <p class="code"><%= heading %></p>
        <h2><i class="fa-solid fa-triangle-exclamation" style="color:var(--danger);font-size:1.4rem;"></i> Something Went Wrong</h2>
        <p><%= message %></p>
        <div class="btn-row" style="justify-content:center;gap:14px;">
            <a class="btn btn-secondary" href="javascript:history.back()">
                <i class="fa-solid fa-arrow-left"></i> Go Back
            </a>
            <a class="btn btn-accent btn-lg" href="<%=request.getContextPath()%>/index.jsp">
                <i class="fa-solid fa-house"></i> Return to Homepage
            </a>
        </div>
    </div>
</div>
</body>
</html>

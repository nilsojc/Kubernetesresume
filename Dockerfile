FROM httpd
COPY detailed-resume.html /usr/local/apache2/htdocs/index.html
COPY style.css /usr/local/apache2/htdocs/style.css
COPY headshot.jpg /usr/local/apache2/htdocs/headshot.jpg
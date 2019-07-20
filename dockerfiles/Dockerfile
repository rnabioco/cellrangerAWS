FROM ubuntu:18.04

# Add cellranger
RUN mkdir /software /INPUT /RESULTS
ADD cellranger-3.0.2.tar.gz /software

# Add snakemake pipeline
COPY PIPELINE /PIPELINE

# Install packages
RUN apt-get update && apt-get -y install python3 python3-pip cron wget
RUN pip3 install snakemake
RUN wget -qO /usr/bin/batchit https://github.com/base2genomics/batchit/releases/latest/download/batchit
RUN chmod +x /usr/bin/batchit

# Expose port 22
#EXPOSE 22/tcp

# Copy sleep-cron file to the cron.d directory
COPY sleep-cron /etc/cron.d/sleep-cron

# Add cron job
RUN crontab /etc/cron.d/sleep-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run pipeline on container boot
CMD cron && tail -f /var/log/cron.log


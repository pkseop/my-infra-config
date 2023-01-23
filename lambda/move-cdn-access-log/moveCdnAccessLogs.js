// Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0
const aws = require('aws-sdk');
const s3 = new aws.S3({ apiVersion: '2006-03-01' });

// prefix to copy partitioned data to w/o leading but w/ trailing slash
const targetKeyPrefix = "stream_cdn_log"

// regex for filenames by Amazon CloudFront access logs. Groups:
// - 1.	year
// - 2.	month
// - 3.	day 
// - 4.	hour
const datePattern = '[^\\d](\\d{4})-(\\d{2})-(\\d{2})-(\\d{2})[^\\d]';
const filenamePattern = '[^/]+$';
const GMT=9;

exports.handler = async (event, context, callback) => {
  const moves = event.Records.map(record => {
    const bucket = record.s3.bucket.name;
    const sourceKey = record.s3.object.key;

    const sourceRegex = new RegExp(datePattern, 'g');
    const match = sourceRegex.exec(sourceKey);
    if (match == null) {
      console.log(`Object key ${sourceKey} does not look like an access log file, so it will not be moved.`);
    } else {
      const [, year, month, day, hour] = match;
      const date = new Date(year, month-1, day, hour, 0, 0);
      date.setTime(date.getTime() + GMT * 60 * 60 * 1000);
      console.log("current date: " + date);

      const filenameRegex = new RegExp(filenamePattern, 'g');
      const filename = filenameRegex.exec(sourceKey)[0];
      const targetYear = date.getFullYear();
      var targetMonth = date.getMonth() + 1;
      if(targetMonth < 10) {
        targetMonth = '0' + targetMonth;
      }
      var targetDay = date.getDate();
      if(targetDay < 10) {
        targetDay = '0' + targetDay;
      }

      const targetKey = `${targetKeyPrefix}/${targetYear}/${targetMonth}/${targetDay}/${filename}`;
      console.log(`Copying ${sourceKey} to ${targetKey}.`);

      const copyParams = {
        CopySource: bucket + '/' + sourceKey,
        Bucket: bucket,
        Key: targetKey
      };
      const copy = s3.copyObject(copyParams).promise();

      const deleteParams = { Bucket: bucket, Key: sourceKey };

      return copy.then(function () {
        console.log(`Copied. Now deleting ${sourceKey}.`);
        const del = s3.deleteObject(deleteParams).promise();
        console.log(`Deleted ${sourceKey}.`);
        return del;
      }, function (reason) {
        const error = new Error(`Error while copying ${sourceKey}: ${reason}`);
        callback(error);
      });

    }
  });
  await Promise.all(moves);
};
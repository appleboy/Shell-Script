#!/usr/bin/env python
"""
    fix_s3_cache_headers
    ~~~~~~~~

    Updates S3 objects with new cache-control headers.

    Usage::
        python fix_cloudfront.py <bucket_name> <keys>*

    Examples::
        Updates all keys of avatars.wedoist.com bucket::
            python fix_cloudfront.py avatars.wedoist.com

        Updates only one key::
            python fix_cloudfront.py avatars.w.com d39c2.gif

    Read more here::
        http://amix.dk/blog/post/19687

    :copyright: by Amir Salihefendic ( http://amix.dk/ )
    :license: MIT
"""
import sys
import mimetypes
import email
import time
import types
from datetime import datetime, timedelta

from boto.s3.connection import S3Connection
from boto.cloudfront import CloudFrontConnection


#--- AWS credentials ----------------------------------------------
AWS_KEY = ''
AWS_SECRET = ''

#--- Main function ----------------------------------------------
def main(s3_bucket_name, keys=None):
    s3_conn = S3Connection(AWS_KEY, AWS_SECRET)

    bucket = s3_conn.get_bucket(s3_bucket_name)

    if not keys:
        keys = bucket.list()

    for key in keys:
        if type(key) == types.StringType:
            key_name = key
            key = bucket.get_key(key)
            if not key:
                print 'Key not found %s' % key_name
                continue

        # Force a fetch to get metadata
        # see this why: http://goo.gl/nLWt9
        key = bucket.get_key(key.name)

        aggressive_headers = _get_aggressive_cache_headers(key)
        key.copy(s3_bucket_name, key, metadata=aggressive_headers, preserve_acl=True)
        print 'Updated headers for %s' % key.name

#--- Helpers ----------------------------------------------
def _get_aggressive_cache_headers(key):
    metadata = key.metadata

    metadata['Content-Type'] = key.content_type

    # HTTP/1.0 (5 years)
    metadata['Expires'] = '%s GMT' %\
        (email.Utils.formatdate(
            time.mktime((datetime.now() +
            timedelta(days=365*5)).timetuple())))

    # HTTP/1.1 (5 years)
    metadata['Cache-Control'] = 'max-age=%d, public' % (3600 * 24 * 360 * 5)

    # add gzip encoding, it brings some error on css or js file by appleboy
    # metadata['Content-Encoding'] = 'gzip'

    return metadata

if __name__ == '__main__':
    main( sys.argv[1],
          sys.argv[2:] )

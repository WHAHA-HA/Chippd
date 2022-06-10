## S3 Javascript Uploader

This folder contains the javascript uploader which is used to directly upload
user content to s3. The uploader interface is made using Knockout.js.

## Using the uploader

To use the uploader, you will have to make sure that the
`my_chippd/sections/uploader_templates` partial is loaded since it contains the
knockout templates. You should also include the uploader javascript files (you
can use `require s3uploader/s3uploader`) unless they are already included.

### For single file uploads

You should insert the following html snippet in the document where you want to
show the uploader:

    <div id="uploader_target" data-bind="template: 'singleUpload'">
      <p style="color: #ccc">Loading...</p>
    </div>

Depending on the file type you should execute the following Javascript code to
initialize the uploader:

    $(function () {
      var existing = {
        url: "<place the existing url here if there's any>"
      };
      $("#uploader_target").initSingleUpload(existing, "<file type, eg. image>");
    });

For example, if you want to use the uploader for images, the snippet should
look like this:

    $(function () {
      var existing = {
        url: "<place the existing url here if there's any>"
      };
      $("#uploader_target").initSingleUpload(existing, "image");
    });

### For multi file uploads

Using the multi file uploader is similar. You should insert the following html
snippet in the document where you want to show the uploader:

    <div id="uploader_target" data-bind="template: 'uploads'">
      <p style="color: #ccc">Loading...</p>
    </div>

As you can see, the difference is in the template that we are rendering. The
Javascript code that should be executed to initialize the uploader is a bit
different. To give you a better idea of how to use it, here's the actual code
used for the gallery section:

    $(function () {
      var existing = <%= raw @section.gallery_images_json %>
      $("#uploader_target").initMultiUpload(existing, {
        type: "image",
        max: <%= Gallery::MAXIMUM_NUMBER_OF_IMAGES %>,
        min: <%= Gallery::MINIMUM_NUMBER_OF_IMAGES %>
      });
    });

The `existing` variable is an array of objects that contain the `id` and `url`
properties. These are then used to show the existing images in the gallery. The
same approach should be used for other file types. If the `id` property doesn't
exist for some file type, the easiest workaround would be to hash the url and
use that as the `id`.

We also need to provide additional properties: `type`, `min` and `max`. The
`type` property is the same that is used for single file uploads. `max` and `min`
are used to limit the number of files the user can upload.

## Supporting other file types

*Note*: This section will probably change as we are working on the uploader.

There are two steps that need to be done to support a file type.

The first one is to register the new file type in the `acceptsMap` map in
`file_upload.js`. This map is used to specify the allowed mime types for each
file type.

The second step is to write the representation template. This template is then
used to render existing files when editing. The template should be defined in
the `my_chippd/sections/uploader_templates` partial. For example, this is the
representation template for the image file type:

    <script type="text/html" id="representations/image">
      <div class="current">
        <div class="image-wrap">
          <p>Current Image</p>
          <img data-bind="{attr: { src: url }}" />
        </div>
      </div>
    </script>

The `id` of the script tag should be set to `representations/<file_type>`.

For some more complicated file types (like the video type) it's possible to use
the template to simply render server-generated html content—which is passed
through when intializing the uploader.

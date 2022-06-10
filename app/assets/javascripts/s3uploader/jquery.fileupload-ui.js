/**
 * Custom jquery Chippd File Uploader
 * Extends chippd file upladoer and add all UI interactions here
 * Used Deferred/Promise Model for multi fle upload handling...
 * S3 Uploader internally implemented use callback to store URL to backend
 * Form data is submitted with following of format
 */

/* jshint nomen:false */
/* global define, window */

(function (factory) {
    'use strict';
    if (typeof define === 'function' && define.amd) {
        // Register as an anonymous AMD module:
        define([
            'jquery',
            'tmpl',
            './jquery.fileupload-image',
            './jquery.fileupload-audio',
            './jquery.fileupload-validate'
        ], factory);
    } else {
        // Browser globals:
        factory(
            window.jQuery,
            window.tmpl
        );
    }
}(function ($, tmpl) {
    'use strict';

    $.chippd.fileupload.prototype._specialOptions.push(
        'filesContainer',
        'uploadTemplateId',
        'downloadTemplateId'
    );

    // The UI version extends the  chippd file upload widget
    // and adds complete user interface interaction:
    $.widget('chippd.fileupload', $.chippd.fileupload, {

        options: {
            // By default, files added to the widget are uploaded as soon
            // as the user clicks on the start buttons. To enable automatic
            // uploads, set the following option to true:
            autoUpload: false,
            //check if files are already uploaded...
            isUploaded : false,
            //single upload or multiupload:
            multiUpload: false,
            //hidden file name to rails controller,
            hiddenField: 'upload',
            //upload wrapper class,
            uploadWrapper: undefined,
            //The ID of file box,
            uploadFileBox : 'file-uploader',
            //templateKeys that match file and inputtemplateID,
            fileTemplateKey : undefined,
            //file input template ID,
            fileInputTemplateId:'single-file-upload',
            //file error templateID
            fileErrorTemplateId: 'file-error-id',
            //file template conatiner ID,
            fileTemplateContainerId :'file-input-section',
            // The ID of the upload template:
            uploadTemplateId: 'template-upload',
            // The ID of the download template:
            downloadTemplateId: 'template-download',
            // The container for the list of files. If undefined, it is set to
            // an element with class "files" inside of the widget element:
            existingTemplateId: 'representations-image',
            // The container for the list of existing files
            filesContainer: undefined,
            // By default, files are appended to the files container.
            // Set the following option to true, to prepend files instead:
            existingFiles: undefined,
            // By default exisiting  files are empty
            // they will be set by JSON array
            contextClass: undefined,
            //show file name,
            replaceFileInput:false,
            //by default context classs deals with mostly files types
            //will be added  in constructor
            prependFiles: false,
            // The expected data type of the upload response, sets the dataType
            // option of the $.ajax upload requests:
            dataType: 'json',
            
            // Error and info messages:
            messages: {
                unknownError: 'Unknown error'  
            },

            // Function returning the current number of files,
            // used by the maxNumberOfFiles validation:
            getNumberOfFiles: function () {
                return this.filesContainer.children()
                    .not('.processing').length;
            },

            // Callback to retrieve the list of files from the server response:
            getFilesFromResponse: function (data) {
                if (data.result && $.isArray(data.result.files)) {
                    return data.result.files;
                }
                return [];
            },

            // The add callback is invoked as soon as files are added to the fileupload
            // widget (via file input selection, drag & drop or add API call).
            // See the basic file upload widget for more information:
            add: function (e, data) {
                if (e.isDefaultPrevented()) {
                    return false;
                }
                var $this = $(this),
                    that = $this.data('blueimp-fileupload') ||
                        $this.data('fileupload'),
                    options = that.options;

                data.context = that._renderUpload(data.files)
                    .data('data', data)
                    .addClass('processing');

                console.log('file valid?');
                console.log(data.files.valid);
                console.log('read files');
                console.log(data.files);

                var templateIndex = data.fileInput.data('index');

                //add to original files container...
               /* options.filesContainer[
                    options.prependFiles ? 'prepend' : 'append'
                ](data.context);*/

                //add to new ones...
                //not showing progress bar ,only shows when startre

                var uploadingbar = data.form.find('.files').filter('[data-index='+templateIndex+']');
                uploadingbar.empty();

                //hide file error / required message...
                //data.fileInput.closest('#file-error-id').empty();
                uploadingbar.parent().find('#file-error-id').empty();

                /*uploadingbar[
                    options.prependFiles ? 'prepend' : 'append'
                    ](data.context);*/
                //
                data.context.hide().appendTo(uploadingbar);
                that._forceReflow(data.context);
                that._transition(data.context);


                //track data.context
                console.log(data.context);
                console.log('.start button prop');
                console.log(data.context.find('.start').prop('disabled'));

                 data.process(function () {
                            console.log('template processed...');
                            return $this.fileupload('process', data);
                        }).always(function () {

                            //data.context.each(function (index) {
                            data.context.find('.uploading').each(function (index) {
                        $(this).find('.size').val(
                            that._formatFileSize(data.files[index].size)
                        );
                    }).removeClass('processing');
                    that._renderPreviews(data);
                }).done(function () {
                    console.log('start button info');
                    console.log(data.context.find('.start').prop('disabled'));

                    data.context.find('.start').prop('disabled', false);
                    if ((that._trigger('added', e, data) !== false) &&
                            (options.autoUpload || data.autoUpload) &&
                            data.autoUpload !== false) {
                        data.submit();
                    }
                }).fail(function () {
                    if (data.files.error) {
                        data.context.each(function (index) {
                            var error = data.files[index].error;
                            if (error) {
                                $(this).find('.error').text(error);
                            }
                        });
                    }
                });
            },
            // Callback for the start of each file upload request:
            send: function (e, data) {
                if (e.isDefaultPrevented()) {
                    return false;
                }

                var that = $(this).data('blueimp-fileupload') ||
                    $(this).data('fileupload');
                console.log('upload func started');
                console.log($(this).data('blueimp-fileupload'));
                console.log('Here we replace S3 uploader');
                //console.log(data);

                var deferredUpload = $.Deferred();
                //call s3 uploader here
                console.log(data.files[0]);


                self.upload = new S3Upload(data.files[0], {
                    onStart: function () {
                        console.log('upload s3 started');
                    },
                    onTotalAvailable: _.once(function (total) {
                        //self.uploadSize(total);
                        console.log('UploadSize:'+total);
                    }),
                    onProgress: function (progress) {
                        //self.progress(progress);

                        if (e.isDefaultPrevented()) {
                            return false;
                        }

                        if (data.context) {
                            //new progress bar
                            data.context.find('.progress')
                                .attr('aria-valuenow', progress)
                                .children().first().css(
                                'width',
                                    progress + '%'
                            );
                        }

                        console.log(data);
                        console.log('progress :' + progress +'%');
                    },
                    onFinish: function (publicUrl) {
                        //first we have to hide uploading progress bar

                        var dataIndex = data.fileInput.data('index');
                        var uploadingbar = data.form.find('.files').filter('[data-index='+dataIndex+']');
                        uploadingbar.find('.uploading').remove();

                        //here we handle upload stuff...
                        console.log('S3 upload finished');
                        console.log('URL:'+publicUrl);

                        var a= {};
                        var obj = {
                            /*id: a.id,*/
                            id: data.fileInput.data('index'),
                            templateId:data.fileInput.data('index'),
                            url: publicUrl,
                            uploadSize: data.files[0].size
                        };

                        //show be integrated meta fields...

                        //override default hiddenField name of the form in case there are several hidden fields...
                        if(data.fileInput.data('fieldname'))
                        {
                            var fieldName = data.fileInput.data('fieldname');
                            obj = $.extend(obj, {fieldName: fieldName});
                        }

                        //this.result = obj;
                        // data.fileInput.data('submitvalue',JSON.stringify(obj));

                        if(that.options.multiUpload) //store values only in case of multiupload
                        {
                            if(that.uploads)
                            {
                                //if existing replace...
                                //that.uploads = _.filter(that.uploads, function(item){return item.id != dataIndex});
                                var target = _.findWhere(that.uploads, { templateId : dataIndex});
                                //if existing keep id...
                                if(target)
                                    obj.id=target.id;
                                that.uploads = _.filter(that.uploads, function(item){return item.templateId != dataIndex});

                                //if it's new push
                                that.uploads.push(obj);
                            }

                        }else{
                            //very important , for single upload we just ignore existing and overwrite information...
                            that.uploads = [];
                            that.uploads.push(obj);

                           var json = JSON.stringify(that.uploads);
                            console.log(json);
                            var encodedJson = encodeURIComponent(json);
                            console.log(encodedJson);


                            var fieldName = that.options.hiddenField ? that.options.hiddenField : 'upload';

                            if(data.fileInput.data('fieldname'))
                                fieldName = data.fileInput.data('fieldname');

                            var form = $('form');
                            $('<input>').attr({
                                type: 'hidden',
                                id: fieldName,
                                name: fieldName,
                                value: encodedJson
                            }).appendTo(form);

                            //empty stack
                            that.uploads = [];

                        }
                        console.log('current stack');
                        console.log(that.uploads);

                        //update defer
                        deferredUpload.resolve();
                    },
                    onError: function (e) {
                        /*self.error(e);
                         if (_.isFunction(errorCb)) {
                         errorCb(e);
                         }*/
                        deferredUpload.reject();
                        console.error("There was an error while uploading the file: " + e);
                    }
                });

                self.upload.start();

                console.log('in files');
                console.log(data.files);

                //return deferred
                //return deferredUpload.promise();
                return deferredUpload;
                //trigger sent event...
                //return that._trigger('sent', e, data);
            },
            // Callback for successful uploads:
            done: function (e, data) {
                if (e.isDefaultPrevented()) {
                    return false;
                }
                var that = $(this).data('blueimp-fileupload') ||
                        $(this).data('fileupload'),
                    getFilesFromResponse = data.getFilesFromResponse ||
                        that.options.getFilesFromResponse,
                    files = getFilesFromResponse(data),
                    template,
                    deferred;
                console.log('input data');
                console.log(files);
                if (data.context) {

                    $('.fileupload-buttons').find('.delete').show();
                    data.context.each(function (index) {
                        var file = files[index] ||
                                {error: 'Empty file upload result'};
                        deferred = that._addFinishedDeferreds();
                        that._transition($(this)).done(
                            function () {
                                var node = $(this);
                                template = that._renderDownload([file])
                                    .replaceAll(node);
                                that._forceReflow(template);
                                that._transition(template).done(
                                    function () {
                                        data.context = $(this);
                                        that._trigger('completed', e, data);
                                        that._trigger('finished', e, data);
                                        deferred.resolve();
                                    }
                                );
                            }
                        );
                    });
                } else {
                    template = that._renderDownload(files)[
                        that.options.prependFiles ? 'prependTo' : 'appendTo'
                    ](that.options.filesContainer);
                    that._forceReflow(template);
                    deferred = that._addFinishedDeferreds();
                    that._transition(template).done(
                        function () {
                            data.context = $(this);
                            that._trigger('completed', e, data);
                            that._trigger('finished', e, data);
                            deferred.resolve();
                        }
                    );
                }
            },
            // Callback for failed (abort or error) uploads:
            fail: function (e, data) {
                console.log('failed-----');
                if (e.isDefaultPrevented()) {
                    return false;
                }
                //no need to render download templates, just skip it...
                return false;
                var that = $(this).data('blueimp-fileupload') ||
                        $(this).data('fileupload'),
                    template,
                    deferred;
                if (data.context) {
                    data.context.each(function (index) {
                        if (data.errorThrown !== 'abort') {
                            var file = data.files[index];
                            file.error = file.error || data.errorThrown ||
                                data.i18n('unknownError');
                            deferred = that._addFinishedDeferreds();
                            that._transition($(this)).done(
                                function () {
                                    var node = $(this);
                                    template = that._renderDownload([file])
                                        .replaceAll(node);
                                    that._forceReflow(template);
                                    that._transition(template).done(
                                        function () {
                                            data.context = $(this);
                                            that._trigger('failed', e, data);
                                            that._trigger('finished', e, data);
                                            deferred.resolve();
                                        }
                                    );
                                }
                            );
                        } else {
                            deferred = that._addFinishedDeferreds();
                            that._transition($(this)).done(
                                function () {
                                    $(this).remove();
                                    that._trigger('failed', e, data);
                                    that._trigger('finished', e, data);
                                    deferred.resolve();
                                }
                            );
                        }
                    });
                } else if (data.errorThrown !== 'abort') {
                    data.context = that._renderUpload(data.files)[
                        that.options.prependFiles ? 'prependTo' : 'appendTo'
                    ](that.options.file0sContainer)
                        .data('data', data);
                    that._forceReflow(data.context);
                    deferred = that._addFinishedDeferreds();
                    that._transition(data.context).done(
                        function () {
                            data.context = $(this);
                            that._trigger('failed', e, data);
                            that._trigger('finished', e, data);
                            deferred.resolve();
                        }
                    );
                } else {
                    that._trigger('failed', e, data);
                    that._trigger('finished', e, data);
                    that._addFinishedDeferreds().resolve();
                }
            },
            // Callback for upload progress events:
            progress: function (e, data) {
                //incase of s3 upload
                return;
                if (e.isDefaultPrevented()) {
                    return false;
                }
                var progress = Math.floor(data.loaded / data.total * 100);
                if (data.context) {
                    data.context.each(function () {
                        $(this).find('.progress')
                            .attr('aria-valuenow', progress)
                            .children().first().css(
                                'width',
                                progress + '%'
                            );
                    });
                }
            },
            // Callback for global upload progress events:
            progressall: function (e, data) {
                if (e.isDefaultPrevented()) {
                    return false;
                }
                var $this = $(this),
                    progress = Math.floor(data.loaded / data.total * 100),
                    globalProgressNode = $this.find('.fileupload-progress'),
                    extendedProgressNode = globalProgressNode
                        .find('.progress-extended');
                if (extendedProgressNode.length) {
                    extendedProgressNode.html(
                        ($this.data('blueimp-fileupload') || $this.data('fileupload'))
                            ._renderExtendedProgress(data)
                    );
                }
                globalProgressNode
                    .find('.progress')
                    .attr('aria-valuenow', progress)
                    .children().first().css(
                        'width',
                        progress + '%'
                    );
            },
            // Callback for uploads start, equivalent to the global ajaxStart event:
            start: function (e) {

                //alert('start');
                if (e.isDefaultPrevented()) {
                    return false;
                }
                var that = $(this).data('blueimp-fileupload') ||
                        $(this).data('fileupload');

                that._resetFinishedDeferreds();

                that._transition($(this).find('.fileupload-progress')).done(
                    function () {
                        that._trigger('started', e);
                     }
                );
            },
            // Callback for uploads stop, equivalent to the global ajaxStop event:
            stop: function (e) {
                if (e.isDefaultPrevented()) {
                    return false;
                }
                var that = $(this).data('blueimp-fileupload') ||
                        $(this).data('fileupload'),
                    deferred = that._addFinishedDeferreds();
                $.when.apply($, that._getFinishedDeferreds())
                    .done(function () {
                        that._trigger('stopped', e);
                    });
                that._transition($(this).find('.fileupload-progress')).done(
                    function () {
                        $(this).find('.progress')
                            .attr('aria-valuenow', '0')
                            .children().first().css('width', '0%');
                        $(this).find('.progress-extended').html('&nbsp;');
                        deferred.resolve();
                    }
                );
            },
            processstart: function (e) {
                if (e.isDefaultPrevented()) {
                    return false;
                }
                $(this).addClass('fileupload-processing');
            },
            processstop: function (e) {
                if (e.isDefaultPrevented()) {
                    return false;
                }
                $(this).removeClass('fileupload-processing');
            },
            // Callback for file deletion:
            destroy: function (e, data) {

                if (e.isDefaultPrevented()) {
                    return false;
                }

                var that = $(this).data('blueimp-fileupload') ||
                        $(this).data('fileupload'),
                    removeNode = function () {
                        that._transition(data.context).done(
                            function () {
                                console.log('REMOVE CALLED');
                                console.log($(this));
                                $(this).remove();
                                that._trigger('destroyed', e, data);
                            }
                        );
                    };

                if (data.url) {
                    data.dataType = data.dataType || that.options.dataType;

                    data.url += '?attachid='+ data.attachid+"&post_id="+data.postid+"&photo_field="+data.photofield;
                    console.log(data);

                    $.ajax(data).done(
                        function(data){
                            console.log('success');
                            console.log(data);
                            removeNode();
                        }).fail(function (jqXHR, status) {
                        console.log(jqXHR);
                        console.log(status);

                        that._trigger('destroyfailed', e, data);
                    });
                } else {
                    console.log('deleting data');
        console.log(data);
    if(self.uploads) {
        console.log('self-uploads stack check');
        console.log(that.uploads);
    }
    removeNode();
}
}
},

_resetFinishedDeferreds: function () {
    this._finishedUploads = [];

},
        _addFinishedDeferreds: function (deferred) {
            if (!deferred) {
                deferred = $.Deferred();
            }
            this._finishedUploads.push(deferred);
            return deferred;
        },

        _getFinishedDeferreds: function () {
            return this._finishedUploads;
        },

        // Link handler, that allows to download files
        // by drag & drop of the links to the desktop:
        _enableDragToDesktop: function () {
            var link = $(this),
                url = link.prop('href'),
                name = link.prop('download'),
                type = 'application/octet-stream';
            link.bind('dragstart', function (e) {
                try {
                    e.originalEvent.dataTransfer.setData(
                        'DownloadURL',
                        [type, name, url].join(':')
                    );
                } catch (ignore) {}
            });
        },

        _formatFileSize: function (bytes) {
            if (typeof bytes !== 'number') {
                return '';
            }
            if (bytes >= 1000000000) {
                return (bytes / 1000000000).toFixed(2) + ' GB';
            }
            if (bytes >= 1000000) {
                return (bytes / 1000000).toFixed(2) + ' MB';
            }
            return (bytes / 1000).toFixed(2) + ' KB';
        },

        _formatBitrate: function (bits) {
            if (typeof bits !== 'number') {
                return '';
            }
            if (bits >= 1000000000) {
                return (bits / 1000000000).toFixed(2) + ' Gbit/s';
            }
            if (bits >= 1000000) {
                return (bits / 1000000).toFixed(2) + ' Mbit/s';
            }
            if (bits >= 1000) {
                return (bits / 1000).toFixed(2) + ' kbit/s';
            }
            return bits.toFixed(2) + ' bit/s';
        },

        _formatTime: function (seconds) {
            var date = new Date(seconds * 1000),
                days = Math.floor(seconds / 86400);
            days = days ? days + 'd ' : '';
            return days +
                ('0' + date.getUTCHours()).slice(-2) + ':' +
                ('0' + date.getUTCMinutes()).slice(-2) + ':' +
                ('0' + date.getUTCSeconds()).slice(-2);
        },

        _formatPercentage: function (floatValue) {
            return (floatValue * 100).toFixed(2) + ' %';
        },

        _renderExtendedProgress: function (data) {
            return this._formatBitrate(data.bitrate) + ' | ' +
                this._formatTime(
                    (data.total - data.loaded) * 8 / data.bitrate
                ) + ' | ' +
                this._formatPercentage(
                    data.loaded / data.total
                ) + ' | ' +
                this._formatFileSize(data.loaded) + ' / ' +
                this._formatFileSize(data.total);
        },

        _renderTemplate: function (func, files) {
            if (!func) {
                return $();
            }

            console.log('rendering template result');
            var result = tmpl(func, {
                files: files,
                formatFileSize: this._formatFileSize,
                options: this.options
            });

            if(result instanceof $){
                return result;
            }

            console.log(result);
            return $(this.options.templatesContainer).html(result).children();
        },

        _renderPreviews: function (data) {
            data.context.find('.preview').each(function (index, elm) {
                $(elm).append(data.files[index].preview);
            });
        },

        _renderUpload: function (files) {
            console.log('rendering upload');
            console.log(this.options.uploadTemplate);
            console.log(files);

            return this._renderTemplate(
                this.options.uploadTemplate,
                files
            );
        },

        _renderFileError: function (container,data) {
            /*sample data
            {
                index: index,
                    error: error
            }
            */
            console.log('rendering file error');

            var result = tmpl($("#file-error"), data);

            console.log(result);

            //in case multi upload we need to find individual widget
            //otherwise
            if(data.index && data.index ==0)
            {
                //$('#'+containerID).html(result);
                $(container).html(result);

            }else{
                //find container...
                $(container).html(result);
            }

        },
        _renderDownload: function (files) {
            return this._renderTemplate(
                this.options.downloadTemplate,
                files
            ).find('a[download]').each(this._enableDragToDesktop).end();
        },
        _renderFile : function() {
            return this._renderTemplate(
                this.options.uploadFileInput,
                null
            );
        },
        _renderExisting : function(files) {
            //for render existing this is the
            /*return this._renderTemplate(
                this.options.existingTemplate,
                files
            );*/
            //for new version...

            //in case of only one submit fields we jut iterate....

            if(!(this.options.fileInputTemplateId instanceof Array) && !(this.options.fileTemplateContainerId instanceof Array) && !_.isObject(this.options.fileInputTemplateId))//all in one field
            {
                var fileInputTemplate = this.options.fileInputTemplateId ?  this.options.fileInputTemplateId : 'single-file-upload';
                console.log('render existing');
                console.log(files);

                //clear container...
                var fileTemplateContainerId = this.options.fileTemplateContainerId ? this.options.fileTemplateContainerId : 'file-input-section';
                this.element.find('#'+fileTemplateContainerId).empty();
                _.each(files,function(file){
                    //this should be included as context

                    //init number of widgets it not
                    if(!this.options.numberofWidgets)
                        this.options.numberofWidgets = 0;

                    //add widgets number;
                    this.options.numberofWidgets++;

                    var templateInfo = {index: 0};
                    if(file)
                        templateInfo.file = file;

                    templateInfo.index =  this.options.numberofWidgets;
                    console.log(templateInfo);

                    var initUploader = tmpl($('#'+fileInputTemplate),templateInfo);
                    console.log(initUploader);

                    this.element.find('#'+fileTemplateContainerId).append(initUploader);

                },this);
            }else { //more than 2..

                var templatesCount = this.options.fileInputTemplateId.length;
                var containerCount = this.options.fileTemplateContainerId.length;
                //single upload, we have only 2 templates and files maxium
                if(!this.options.multiUpload) //like the couple and etc
                {
                    for(var i=0; i<templatesCount; i++)
                    {
                        var fileInputTemplate = this.options.fileInputTemplateId[i] ?  this.options.fileInputTemplateId[i] : 'single-file-upload';

                        var templateInfo = {index: 0};
                       if((typeof files != 'undefined') && files && files[i])
                       {
                           templateInfo.file = files[i];
                       }
                        else
                       {
                           //templateInfo.file = null;
                           console.log('NO files');
                       }

                        //init number of widgest
                        if(!this.options.numberofWidgets)
                            this.options.numberofWidgets = 0;
                        //add widgets number
                        this.options.numberofWidgets++;
                        templateInfo.index =  this.options.numberofWidgets ? this.options.numberofWidgets : 1;

                        var initUploader = tmpl($('#'+fileInputTemplate),templateInfo);
                        console.log('XXXX');
                        console.log(templateInfo);;
                        console.log(initUploader);

                        var fileTemplateContainerId = this.options.fileTemplateContainerId[i] ? this.options.fileTemplateContainerId[i] : 'file-input-section';
                        //this.element.find('#'+fileTemplateContainerId).append(initUploader);
                        this.element.find('#'+fileTemplateContainerId).empty().append(initUploader);

                    }
                }else{ //multi upload i.e wedding_party
                    //we iterate file and each file information has template_id related information...
                    /*
                     multiUpload             : true,
                     fileTemplateKey         : 'image_type',
                     fileInputTemplateId     :  {'bridesmaid':'multi_wedding_party_upload','groomsman':'multi_wedding_party_upload_2'},
                     fileTemplateContainerId :  {'bridesmaid':'bride_section','groomsman':'groom_section'},
                    */
                    if(this.options.fileTemplateKey)
                    {
                        for(var i=0;i<files.length;i++)
                        {

                            var templateKey = files[i][this.options.fileTemplateKey];

                            var fileInputTemplate = this.options.fileInputTemplateId[templateKey] ?  this.options.fileInputTemplateId[templateKey] : 'single-file-upload';

                            var templateInfo = {index: 0};
                            if(typeof files != 'undefined' && files[i])
                                templateInfo.file = files[i];
                            else
                                continue;

                            //Keep the number of widgets...
                            if(!this.options.numberofWidgets)
                                this.options.numberofWidgets = 0;

                            this.options.numberofWidgets++;

                            templateInfo.index =  this.options.numberofWidgets ? this.options.numberofWidgets : 1;

                            var initUploader = tmpl($('#'+fileInputTemplate),templateInfo);
                            console.log(templateInfo);
                            console.log(initUploader);


                            var fileTemplateContainerId = this.options.fileTemplateContainerId[templateKey] ? this.options.fileTemplateContainerId[templateKey] : 'file-input-section';
                            this.element.find('#'+fileTemplateContainerId).append(initUploader);

                        }
                    }
                }

            }

        },
        _startHandler: function (e) {
            console.log('start button clicked');
            e.preventDefault();
            var button = $(e.currentTarget),
                //template = button.closest('.template-upload'),
                template = button.closest('.uploading'),
                data = template.data('data');
            button.prop('disabled', true);
            //normal workflow of ajax, but not calling ajax just calling s3 uploader
            if (data && data.submit) {
                console.log(data);
                data.submit();
            }
        },


        _cancelHandler: function (e) {
            e.preventDefault();
            var template = $(e.currentTarget)
                    .closest('.template-upload,.template-download'),
                data = template.data('data') || {};
            data.context = data.context || template;
            if (data.abort) {
                data.abort();
            } else {
                data.errorThrown = 'abort';
                this._trigger('fail', e, data);
            }
        },

        _deleteHandler: function (e) {
            e.preventDefault();
            var button = $(e.currentTarget);
            this._trigger('destroy', e, $.extend({
                context: button.closest('.template-download'),
                type: 'DELETE'
            }, button.data()));
        },

        _forceReflow: function (node) {
            return $.support.transition && node.length &&
                node[0].offsetWidth;
        },

        _transition: function (node) {
            var dfd = $.Deferred();
            if ($.support.transition && node.hasClass('fade') && node.is(':visible')) {
                node.bind(
                    $.support.transition.end,
                    function (e) {
                        // Make sure we don't respond to other transitions events
                        // in the container element, e.g. from button elements:
                        if (e.target === node[0]) {
                            node.unbind($.support.transition.end);
                            dfd.resolveWith(node);
                        }
                    }
                ).toggleClass('in');
            } else {
                node.toggleClass('in');
                dfd.resolveWith(node);
            }
            return dfd;
        },

        _initButtonBarEventHandlers: function () {
            var fileUploadButtonBar = this.element.find('.fileupload-buttonbar'),
                filesList = this.options.filesContainer;
            this._on(fileUploadButtonBar.find('.start'), {
                click: function (e) {
                    e.preventDefault();

                    filesList.find('.start').click();
                }
            });
            this._on(fileUploadButtonBar.find('.cancel'), {
                click: function (e) {
                    e.preventDefault();
                    filesList.find('.cancel').click();
                }
            });
            //main delete function
            this._on(fileUploadButtonBar.find('.delete'), {
                click: function (e) {
                    e.preventDefault();
                    console.log('main delete');
                    //filesList.find('.toggle:checked')
                    filesList.find('.template-download')
                        .find('.delete').click();
                    //hide delete all button
                    fileUploadButtonBar.find('.delete').hide();
                    //this is for unchecking main check box
                    /*fileUploadButtonBar.find('.toggle')
                        .prop('checked', false);*/
                }
            });
            //main check box
            this._on(fileUploadButtonBar.find('.toggle'), {
                change: function (e) {
                    console.log('main delete');
                    filesList.find('.toggle').prop(
                        'checked',
                        $(e.currentTarget).is(':checked')
                    );
                }
            });
            if(this.options.multiUpload && !this.isInitialized) //in case multi upload
            {
                //multi upload add another button
                /*var btnAddAnother = this.element.find('.addAnother');
                this._on(btnAddAnother,{
                    click: function(e)
                    {
                        e.preventDefault();
                        console.log('adding template');
                        var fileInputTemplate = this.options.fileInputTemplateId ?  this.options.fileInputTemplateId : 'single-file-upload';

                        //in case of multi templates
                        alert(btnAddAnother.data('inputtemplate'));
                        console.log(fileInputTemplate);

                        var templateInfo = {index: 0};
                        this.numberofWidgets ++;
                        templateInfo.index =  this.numberofWidgets ? this.numberofWidgets : 1;

                        var initUploader = tmpl($('#'+fileInputTemplate),templateInfo);
                        console.log(initUploader);


                        var fileTemplateContainerId = this.options.fileTemplateContainerId ? this.options.fileTemplateContainerId : 'file-input-section';

                        //in case of multi templates
                        alert(btnAddAnother.data('templatecontainer'));
                        this.element.find('#'+fileTemplateContainerId).append(initUploader);

                        //resuable..
                        //_initEventHandlers
                        this.isInitialized = true;
                        //we don't need this as  live events  work
                       // this._initEventHandlers();

                    }
                });*/
              var that = this;
             $('.addAnother, .add-instance').live('click',function(e){
                //add multiupload file validation check

                var added = that.filesAdded(null);
                if(!added)
                    return;
                //add multiupload files
                 e.preventDefault();
                 console.log('adding template');
                 var fileInputTemplate = that.options.fileInputTemplateId ?  that.options.fileInputTemplateId : 'single-file-upload';

                 //in case of multi templates
                 if($(this).data('inputtemplate'))
                    fileInputTemplate = $(this).data('inputtemplate');

                 console.log(fileInputTemplate);

                 var templateInfo = {index: 0};

                 if(that.options.numberofWidgets)
                    that.options.numberofWidgets ++;
                 else
                    that.options.numberofWidgets = 1;

                 templateInfo.index =  that.options.numberofWidgets ? that.options.numberofWidgets : 1;


                 var initUploader = tmpl($('#'+fileInputTemplate),templateInfo);
                 console.log(initUploader);


                 var fileTemplateContainerId = that.options.fileTemplateContainerId ? that.options.fileTemplateContainerId : 'file-input-section';

                 //in case of multi templates
                 if($(this).data('templatecontainer'))
                    fileTemplateContainerId =$(this).data('templatecontainer');
                 that.element.find('#'+fileTemplateContainerId).append(initUploader);

                 //resuable..
                 //_initEventHandlers
                 that.isInitialized = true;
                 //we don't need this as  live events  work
                 // this._initEventHandlers();
                });
                //multi upload remove individual widget

                //$('a.btnRemoveWidget').live('click',function(e)
                $('a.remove-instance').live('click',function(e)
                {
                    e.preventDefault();
                    var btnRemove = $(this);
                    console.log('removing template');
                    var parent = btnRemove.parent();
                    parent.remove();
                    //also remove bound data in stack...
                    if(that.options.numberofWidgets)
                        that.options.numberofWidgets--;
                });
                //not caling it again
                this.isInitialized = true;
            }

        },

        _destroyButtonBarEventHandlers: function () {
            this._off(
                this.element.find('.fileupload-buttonbar')
                    .find('.start, .cancel, .delete'),
                'click'
            );
            this._off(
                this.element.find('.fileupload-buttonbar .toggle'),
                'change.'
            );
        },
        uploadToS3: function (e, data) {
            if (e.isDefaultPrevented()) {
                return false;
            }
            var that = this;

            console.log('upload func started');
            console.log($(this).data('blueimp-fileupload'));
            console.log('Here we replace S3 uploader');
            //console.log(data);

            var deferredUpload = $.Deferred();
            //call s3 uploader here
            console.log(data.files[0]);

            //show progress bar added...
            var dataIndex = data.fileInput.data('index');
            var uploadingbar = data.form.find('.files').filter('[data-index='+dataIndex+']');
            uploadingbar.find('.uploading').show();

            self.upload = new S3Upload(data.files[0], {
                onStart: function () {
                    console.log('upload s3 started');
                },
                onTotalAvailable: _.once(function (total) {
                    //self.uploadSize(total);
                    console.log('UploadSize:'+total);
                }),
                onProgress: function (progress) {
                    //self.progress(progress);

                    if (e.isDefaultPrevented()) {
                        return false;
                    }

                    if (data.context) {
                        //new progress bar
                        data.context.find('.progress')
                            .attr('aria-valuenow', progress)
                            .children().first().css(
                            'width',
                                progress + '%'
                        );
                    }

                    console.log(data);
                    console.log('progress :' + progress +'%');
                },
                onFinish: function (publicUrl) {
                    //first we have to hide uploading progress bar

                    var dataIndex = data.fileInput.data('index');
                    var uploadingbar = data.form.find('.files').filter('[data-index='+dataIndex+']');
                    uploadingbar.find('.uploading').remove();

                    //here we handle upload stuff...
                    console.log('S3 upload finished');
                    console.log('URL:'+publicUrl);

                    var a= {};
                    var obj = {
                        /*id: a.id,*/
                        id: data.fileInput.data('index'),
                        templateId:data.fileInput.data('index'),
                        url: publicUrl,
                        uploadSize: data.files[0].size
                    };

                    //show be integrated meta fields...

                    //override default hiddenField name of the form in case there are several hidden fields...
                    if(data.fileInput.data('fieldname'))
                    {
                        var fieldName = data.fileInput.data('fieldname');
                        obj = $.extend(obj, {fieldName: fieldName});
                    }

                    //this.result = obj;
                    // data.fileInput.data('submitvalue',JSON.stringify(obj));

                    if(that.options.multiUpload) //store values only in case of multiupload
                    {
                        if(that.uploads)
                        {
                            //if existing replace...
                            //that.uploads = _.filter(that.uploads, function(item){return item.id != dataIndex});
                            var target = _.findWhere(that.uploads, { templateId : dataIndex});
                            //if existing keep id...
                            if(target)
                                obj.id=target.id;
                            that.uploads = _.filter(that.uploads, function(item){return item.templateId != dataIndex});

                            //if it's new push
                            that.uploads.push(obj);
                        }

                    }else{
                        //very important , for single upload we just ignore existing and overwrite information...
                        that.uploads = [];
                        that.uploads.push(obj);

                        var json = JSON.stringify(that.uploads);
                        console.log(json);
                        var encodedJson = encodeURIComponent(json);
                        console.log(encodedJson);

                        //this is necessary in case single uploader has multiple hidden fields like baby family...

                        var fieldName = that.options.hiddenField ? that.options.hiddenField : 'upload';

                        if(data.fileInput.data('fieldname'))
                            fieldName = data.fileInput.data('fieldname');

                        var form = $('form');
                        $('<input>').attr({
                            type: 'hidden',
                            id: fieldName,
                            name: fieldName,
                            value: encodedJson
                        }).appendTo(form);

                        //empty stack
                        that.uploads = [];


                    }
                    console.log('current stack');
                    console.log(that.uploads);

                    //update defer
                    deferredUpload.resolve();
                },
                onError: function (e) {
                    deferredUpload.reject();
                    console.error("There was an error while uploading the file: " + e);
                }
            });

            self.upload.start();
            console.log('in files');
            console.log(data.files);

            //return deferred
            return deferredUpload.promise();
            //trigger sent event...
            //return that._trigger('sent', e, data);
        },
        uploadAll: function(form) {
            var that = this;
            var uploadData = [];
            $('.uploading').each(function(index, element){
                var data = $(element).data('data');
                if (data && data.submit) {
                    uploadData.push(data);
                }
            })
            var deferred = $.Deferred();
            var deferreds = _.map(uploadData,function(data) {
                return that.uploadToS3($.Event('send', {}), data);
            });


            //decide whether to submit form or not...

            $.when.apply($, deferreds )
                .done(function() {
                    console.log("XXXXXXXXXXXXXXXXX");
                    that.processS3FileUploads(form);
                    that.options.isUploaded = true;
                    deferred.resolve();
                })
                .fail(function(){
                    console.log('ERRROR');
                    that.options.isUploaded = false;
                    deferred.reject();
                });
            return deferred.promise();
        },
        filesAdded: function(form) {
            var that = this;

            var filesAdded = true;
            console.log(that.uploads);
            if(that.options.multiUpload){ //multi upload
                $('.multi-upload').each(function(index, element){
                    //'.uploading'
                    var uploading = $(this).find('.uploading').length;
                    //file error container
                    var errContainer = $(this).find('#file-error-id');

                    //check exsiting  file
                    var existing = $(this).find('.current').length;

                    if(!uploading && !existing){
                        filesAdded = false;
                        //show file not chosen error
                        var templateIndex = $(this).find('.files').data('index');

                        that._renderFileError(errContainer,{index:templateIndex, error: 0});
                    }else{
                        $(errContainer).empty();
                    }

                })
            }else{ //single upload

                if(!(that.options.fileInputTemplateId instanceof Array) && !(that.options.fileTemplateContainerId instanceof Array) && !_.isObject(that.options.fileInputTemplateId)){//all in one field
                    //if has existing file
                    if($('.current').length>0)
                        return true;
                    //check if file chosen
                    if ($('.uploading').length==0)
                        filesAdded = false;

                    //in case multi widgets e.g the_couple, exeptional

                    if(!filesAdded){
                        //show file not chosen error
                        that._renderFileError($('#file-error-id'),{index:0, error: 0});
                    }else{
                        $('#file-error-id').empty();
                    }    
                } else {
                    //array of file instance..
                    _.each(that.options.fileTemplateContainerId,function(inputTemplate){

                        //if has existing file
                        //if($('#'+inputTemplate).find('.current').length>0)
                        if($('#'+inputTemplate).find('.uploading').length>0)
                            return true;
                        //check if file chosen
                        if ($('#'+inputTemplate).find('.uploading').length==0)
                            filesAdded = false;

                        //in case multi widgets e.g the_couple, exeptional

                        if(!filesAdded){
                            //show file not chosen error
                            that._renderFileError($('#'+inputTemplate).find('#file-error-id'),{index:0, error: 0});
                        }else{
                            $('#'+inputTemplate).find('#file-error-id').empty();
                        }
                    });
                }
                
                


            }
            return filesAdded;
        },
        _initEventHandlers: function () {
            console.log('init event handlers');

            this._super();
            //to enable each upload widget with meta fields work we need to bind live events
            this._on(this.document, {
                'click .uploading .start': this._startHandler,
                'click .uploading .cancel': this._cancelHandler,
                'click .uploading .delete': this._deleteHandler
            });
            this._initButtonBarEventHandlers();
        },

        _destroyEventHandlers: function () {
            this._destroyButtonBarEventHandlers();
            this._off(this.options.filesContainer, 'click');
            this._super();
        },

        _enableFileInputButton: function () {
            this.element.find('.fileinput-button input')
                .prop('disabled', false)
                .parent().removeClass('disabled');
        },

        _disableFileInputButton: function () {
            this.element.find('.fileinput-button input')
                .prop('disabled', true)
                .parent().addClass('disabled');
        },

        _initTemplates: function () {
            var options = this.options;
            options.templatesContainer = this.document[0].createElement(
                options.filesContainer.prop('nodeName')
            );
            if (tmpl) {
                //here we are using new template engines
                //templatesa are precomfield
                //and will be filled with actual values at run time....

                //file input
                //by default we only keep functions of individual not of objects...
                if(options.fileInputTemplateId && !_.isObject(options.fileInputTemplateId)){
                    options.uploadFileInput = options.fileInputTemplateId +"-compiled";
                    jQuery('#'+ options.fileInputTemplateId).template(options.uploadFileInput);
                }

                //upload
                if (options.uploadTemplateId) {
                    options.uploadTemplate =options.uploadTemplateId+"-compiled";
                    jQuery('#'+options.uploadTemplateId).template(options.uploadTemplate);
                }

                //download
                if (options.downloadTemplateId) {
                    options.downloadTemplate = options.downloadTemplateId +"-compiled";
                    jQuery('#'+options.downloadTemplateId).template(options.downloadTemplate);
                }

                //existing
                if (options.existingTemplateId) {
                    options.existingTemplate = options.existingTemplateId+"-compiled";
                    jQuery('#'+options.existingTemplateId).template(options.existingTemplate);
                }

                //file error
                if (options.fileErrorTemplateId) {
                    options.fileErrorTemplate = options.fileErrorTemplateId+"-compiled";
                    jQuery('#'+options.fileErrorTemplateId).template(options.fileErrorTemplate);
                }
            }
        },

        _initFilesContainer: function () {
            var options = this.options;
            console.log('init files container');
            if (options.filesContainer === undefined) {
                options.filesContainer = this.element.find('.files');
                //options.filesContainer = '.files';
            } else if (!(options.filesContainer instanceof $)) {
                options.filesContainer = $(options.filesContainer);
            }

        },
        _doPreProcessor : function () //preprocessing - widgetizing file input box & additional fields itself
        {
            //exisitng files
            //for edit form fixing we render existing data and save associated data...
            //render existing files
            if(this.options.multiUpload || true)
            {
                var data = this.options.existingFiles;
                console.log('render existing files first');
                this._renderExisting(data);
            }
            //set up file input
            console.log('render init file input');
            if(!this.options.existingFiles || !this.options.existingFiles.length)
            {
                if(!(this.options.fileInputTemplateId instanceof Array) && !(this.options.fileTemplateContainerId instanceof Array) && !_.isObject(this.options.fileInputTemplateId))//all in one field
                {
                    var fileInputTemplate = this.options.fileInputTemplateId ?  this.options.fileInputTemplateId : 'single-file-upload';

                    var templateInfo = {index: 0};

                    if(this.options.numberofWidgets)
                        this.options.numberofWidgets++;
                    else
                        this.options.numberofWidgets = 1;

                    templateInfo.index = this.options.numberofWidgets;

                    var initUploader = tmpl($('#'+fileInputTemplate),templateInfo);
                    console.log(initUploader);

                    //get container
                    var fileTemplateContainerId = this.options.fileTemplateContainerId ? this.options.fileTemplateContainerId : 'file-input-section';
                    //render it and append to container...
                    this.element.find('#'+fileTemplateContainerId).empty().append(initUploader);
                }else //more than 2 differnt fields...
                {

                    var templatesCount = this.options.fileInputTemplateId.length;
                    var containerCount = this.options.fileTemplateContainerId.length;
                    //single upload, we have only 2 templates and files maxium
                    if(!this.options.multiUpload)
                    {

                        for(var i=0; i<templatesCount; i++)
                        {
                            var fileInputTemplate = this.options.fileInputTemplateId[i] ?  this.options.fileInputTemplateId[i] : 'single-file-upload';

                            var templateInfo = {index: 0};

                            //keep numberoftemplates
                            if(!this.options.numberofWidgets)
                                this.options.numberofWidgets = 1;
                            else
                                this.options.numberofWidgets++;
                            //allot index with number of widgets...
                            templateInfo.index =  this.options.numberofWidgets;


                            var initUploader = tmpl($('#'+fileInputTemplate),templateInfo);
                            console.log(templateInfo);
                            console.log(initUploader);


                            var fileTemplateContainerId = this.options.fileTemplateContainerId[i] ? this.options.fileTemplateContainerId[i] : 'file-input-section';
                            //this.element.find('#'+fileTemplateContainerId).append(initUploader);
                            this.element.find('#'+fileTemplateContainerId).empty().append(initUploader);
                        }

                    }else{ //multi upload i.e wedding_party
                        //we iterate file and each file information has template_id related information...
                        /*
                         multiUpload             : true,
                         fileTemplateKey         : 'image_type',
                         fileInputTemplateId     :  {'bridesmaid':'multi_wedding_party_upload','groomsman':'multi_wedding_party_upload_2'},
                         fileTemplateContainerId :  {'bridesmaid':'bride_section','groomsman':'groom_section'},
                         */
                        if(this.options.fileTemplateKey)
                        {
                            var that = this;
                            _.each(this.options.fileInputTemplateId, function(templateID,templateKey)
                            {
                                var fileInputTemplate = templateID ?  templateID : 'single-file-upload';

                                var templateInfo = {index: 0};

                                //keep numberofwidgets...
                                if(!that.options.numberofWidgets)
                                    that.options.numberofWidgets = 1;
                                else
                                    that.options.numberofWidgets++;
                                //allot template index with number of widgets...
                                templateInfo.index =  that.options.numberofWidgets;


                                var initUploader = tmpl($('#'+fileInputTemplate),templateInfo);
                                console.log(templateInfo);
                                console.log(initUploader);
                                //get template conatiner
                                var fileTemplateContainerId = that.options.fileTemplateContainerId[templateKey] ? that.options.fileTemplateContainerId[templateKey] : 'file-input-section';
                                //render template and append to container...
                                that.element.find('#'+fileTemplateContainerId).empty().append(initUploader);
                            });
                        }
                    }
                }
            }
        },
        _initSpecialOptions: function () {
            console.log('init special options');
            //do preprocesssing to widgetized file input section itself
            this._doPreProcessor();
            this._super();
            this._initFilesContainer();
            this._initTemplates();

        },
           /* starting point of our uploader
            * Set submit handler
            * init uploads stack
            */
            _create: function () {
                console.log('starting point');
                this._super();
                //init uploads;
                this.uploads = [];

                if(!(this.options.fileInputTemplateId instanceof Array))
                    this.numberofWidgets = 1;
                else
                    this.numberofWidgets = this.options.fileInputTemplateId.length;

                this.isInitialized = false;
                this._resetFinishedDeferreds();
                //init existing files
                var data = this.options.existingFiles;

                if(typeof data != undefined && data != null)
                {
                    console.log('there are exising files');
                    console.log(data);
                    //add files to buffer...re
                    var data_in = {
                        files: data,
                        formatFileSize: this._formatFileSize,
                        options: this.options
                    };

                    //add existing files
                    // #uploader_target add existing files
                    /*if(!this.options.multiUpload)
                        $('#uploader_target').empty().append(this._renderExisting(data));*/
                    //render existing is shifted into preProcessor for multiupload


                    //add files to stack
                    if(this.options.multiUpload) // if multiuplaod we manage stack
                    {
                        var existingIndex = 1;
                        _.each(data,function(element){
                            //this should be included as context
                            var obj = {
                                id: element.id,
                                url: element.url,
                                uploadSize: element.size
                            };
                            //id is db value and we can't use it for saving...
                            //templateId is for distinguishing uplaod widgets...
                            obj.templateId = existingIndex;
                            //if no id...
                            if(!obj.id)
                                obj.id = obj.templateId;

                            existingIndex++;
                            this.uploads.push(obj);
                        },this);
                        console.log('current stack');
                        console.log(this.uploads);
                    }

                }
                if (!$.support.fileInput) {
                    this._disableFileInputButton();
                }
                var parentScope = this;
                var parentElement = $(this);
                //parent form submit handers should be considered by multiupload flag
                //
                var $form;
                $form = $("form");
                var $submit = $('[type=submit]');
                //here we set additional parameters...
                //$(":submit").click(function(e){

                 this._on($form,{submit: function(e){
                     console.log('in submit');
                     console.log(parentScope);
                     var $this = $(this);
                     var that = parentScope;
                     if(!that.options.isUploaded)
                     {
                         //check if file chosen
                         var filesAdded = that.filesAdded($form);
                         if(!filesAdded){//file not added yet
                             return false;
                         }
                         else {
                         //hide file not chosen error

                         //no errors ,we continue uploading files
                         that.uploadAll($(this)).then(function(){
                             console.log("SUBMITTING...");
                             $form.submit();
                             return true;
                         }).fail(function(){
                             console.log('FAILED_______');
                         });
                        }
                         return false;
                     }else{
                         return true;
                     }
                     //return false;
                 }});

                /*$form.submit(function(e){
                    console.log('in submit');
                    console.log(parentScope);
                    var $this = $(this);
                    var that = parentScope;
                    if(!that.options.isUploaded)
                    {
                        that.uploadAll($(this)).then(function(){
                            console.log("SUBMITTING...");
                            $form.submit();
                        }).fail(function(){
                            console.log('FAILED_______');
                        });
                        return false;
                    }
                    return false;

                });*/
            },
            processS3FileUploads : function(form) {
                var that = this;
                if(!that.options.multiUpload ) //if single upload
                {
                   /* console.log('single upload setting');
                     var json = JSON.stringify(that.uploads);
                     console.log(json);
                     var encodedJson = encodeURIComponent(json);
                     console.log(encodedJson);

                     var fieldName = that.options.hiddenField ? that.options.hiddenField : 'upload';

                     $('<input>').attr({
                     type: 'hidden',
                     id: fieldName,
                     name: fieldName,
                     value: encodedJson
                     }).appendTo(form);*/

                     //single fileupload file field....

                }else {
                    // if multi upload , we have to add additional meta fields for each upload if any...
                    //for each multi widget we populate form data
                    var submitUploads= [];
                    $('.multi-upload').each(function(index, element){
                        var templateContainer = $(element);
                        console.log(index);
                        //now we get all fields
                        var fileInput = $(element).find('input[type=file]').data('index');
                        console.log('file Index:'+ fileInput);

                        var metaObj = {};
                        $(element).find('[data-key]').each(function(index, field)
                        {
                            console.log($(field).data('key'));
                            var key = $(field).data('key');
                            if(key !='filesubmit') {

                                //get element type
                                var elementType = $(field).attr('type');
                                //based on element type we retreive values...
                                if (elementType == 'text' || elementType == 'textarea' || elementType =='hidden') //normal text
                                {
                                    metaObj[key] = $(field).val();
                                }
                                else if (elementType =='radio') //radio
                                {
                                    //for timeline assets- each memory has audio/video/photo choice...
                                    var radioValue = templateContainer.find("input:radio[name="+$(field).attr('name')+"]:checked").val();

                                    //in some cases vieo, audio, photo
                                    metaObj[key] = radioValue;
                                }

                            }else{
                                // console.log($(field).data('submitvalue'));
                                var fileIndex = $(field).data('index');
                                //var item = _.find(that.uploads, {id: fileIndex });
                                _.each(that.uploads,function(upload){
                                    if(upload.templateId == fileIndex)
                                    {
                                        metaObj = $.extend(metaObj,upload);
                                    }
                                    console.log(upload);
                                })
                                //checks stack and extend data...
                            }

                        });

                        if(metaObj.templateId !=null)
                        {
                            //very important we need to keep id...
                            if(metaObj.templateId == metaObj.id) //create
                                delete metaObj.id;
                            //template Id not necessary at all
                            delete metaObj['templateId'];
                            //push into stack
                            submitUploads.push(metaObj);
                            console.log(metaObj);
                        }

                    });

                    //for removed data...
                    _.each(that.uploads,function(upload){
                        var inSubmit = _.findWhere(submitUploads, {id : upload.id});
                        if(!inSubmit) // removed
                        {
                            if(upload.id != upload.templateId)//if pre exising but removed?
                            {
                                delete(upload.url);
                                //add deleted items...
                                submitUploads.push(upload);
                            }

                        }
                    });

                    console.log(submitUploads);
                    var json = JSON.stringify(submitUploads);
                    console.log(json);
                    var encodedJson = encodeURIComponent(json);
                    console.log(encodedJson);

                    //add hidden field 'upload' to form before submit
                    var $form;
                    $form = $("form");

                    var fieldName = that.options.hiddenField ? that.options.hiddenField : 'upload';
                    $('<input>').attr({
                        type: 'hidden',
                        id: fieldName,
                        name: fieldName,
                        value: encodedJson
                    }).appendTo($form);
                    //$form

                    //remove uploads...
                    submitUploads.splice(0,submitUploads.length);

                    //addtional file uplaod data added....
                }
            },
            enable: function () {
                var wasDisabled = false;
                if (this.options.disabled) {
                    wasDisabled = true;
                }
                this._super();
            if (wasDisabled) {
                this.element.find('input, button').prop('disabled', false);
                this._enableFileInputButton();
            }
        },

        disable: function () {
            if (!this.options.disabled) {
                this.element.find('input, button').prop('disabled', true);
                this._disableFileInputButton();
            }
            this._super();
        }

    });

}));

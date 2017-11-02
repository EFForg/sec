			/**
			 * @license Copyright (c) 2003-2017, CKSource - Frederico Knabben. All rights reserved.
			 * For licensing, see LICENSE.md or http://ckeditor.com/license
			 
			 * 2017-07-05
			 * the code originally from Frederico Knabben, written in ckeditor-dev-t-13877 branch
			 * (https://github.com/cksource/ckeditor-dev/tree/t/13877)
			 * has been adapted in a plugin by Rpapier for use in Processwire. It hasn't been tested elsewhere.
			 
			 * DESCRIPTION
			 * Filter to paste from Google Doc and keep style (bold, italic, underline)
			 * Those style must be present in the toolbar for it to show, otherwise, it will bypass it
			 
			 * For processwire :
			 * you must edit the field that has CKEditor and make sure that :
			 *	- ACF is On
			 *	- pasteFromGoogleDoc plugin is enabled
			 *	- CKEditor toolbar configuration contains Bold, Italic and Underline
			 *		- e.g : Format, Styles, -, Bold, Italic, Underline, -, RemoveFormat
			 *		if Underline is not in the toolbar for example, it will be bypassed by the filter. 
			 */

			( function() {
				'use strict';

				CKEDITOR.plugins.add( 'pasteFromGoogleDoc', {
					requires: ['clipboard'],

					init: function( editor ) {
						// === arteractive hack for pasteFromGoogleDoc
						
						var filterType,
							filtersFactory = filtersFactoryFactory();
							
						if ( editor.config.forcePasteAsPlainText ) {
							filterType = 'plain-text';
						} else if ( editor.config.pasteFilter ) {
							filterType = editor.config.pasteFilter;
						}
						// On Webkit the pasteFilter defaults to 'webkit-default-filter' because pasted data is so terrible
						// that it must be always filtered. (#13877)
						else if ( CKEDITOR.env.webkit && !( 'pasteFilter' in editor.config ) ) {
							filterType = 'webkit-default-filter';
						}	
							
						//console.log(filterType);
						editor.pasteFilter = filtersFactory.get( filterType );
						
						

						editor.on( 'paste', function( evt ) {
							// Init `dataTransfer` if `paste` event was fired without it, so it will be always available.
							if ( !evt.data.dataTransfer ) {
								evt.data.dataTransfer = new CKEDITOR.plugins.clipboard.dataTransfer();
							}

							// If dataValue is already set (manually or by paste bin), so do not override it.
							if ( evt.data.dataValue ) {
								return;
							}

							var dataTransfer = evt.data.dataTransfer,
								// IE support only text data and throws exception if we try to get html data.
								// This html data object may also be empty if we drag content of the textarea.
								value = dataTransfer.getData( 'text/html' );

							if ( value ) {
								evt.data.dataValue = value;
								evt.data.type = 'html';
							} else {
								// Try to get text data otherwise.
								value = dataTransfer.getData( 'text/plain' );

								if ( value ) {
									evt.data.dataValue = editor.editable().transformPlainTextToHtml( value );
									evt.data.type = 'text';
								}
							}
						}, null, null, 1 );
						
						
						editor.on( 'paste', function( evt ) {
							var dataObj = evt.data,
								type = dataObj.type,
								data = dataObj.dataValue,
								trueType,
								// Default is 'html'.
								defaultType = editor.config.clipboard_defaultContentType || 'html',
								transferType = dataObj.dataTransfer.getTransferType( editor );

							// If forced type is 'html' we don't need to know true data type.
							if ( type == 'html' || dataObj.preSniffing == 'html' ) {
								trueType = 'html';
							} else {
								trueType = recogniseContentType( data );
							}

							// Unify text markup.
							if ( trueType == 'htmlifiedtext' ) {
								data = htmlifiedTextHtmlification( editor.config, data );
							}
							
							// Strip presentational markup & unify text markup.
							// Forced plain text (dialog or forcePAPT).
							// Note: we do not check dontFilter option in this case, because forcePAPT was implemented
							// before pasteFilter and pasteFilter is automatically used on Webkit&Blink since 4.5, so
							// forcePAPT should have priority as it had before 4.5.
							if ( type == 'text' && trueType == 'html' ) {
								data = filterContent( editor, data, filtersFactory.get( 'plain-text' ) );
							}
							// External paste and pasteFilter exists and filtering isn't disabled.
							else if ( transferType == CKEDITOR.DATA_TRANSFER_EXTERNAL && editor.pasteFilter && !dataObj.dontFilter ) {
								
								// 2017-07-05 comment out this filter because it is already processsed somewhere...
								//data = filterContent( editor, data, editor.pasteFilter );
								//console.log(data);
							}

							if ( dataObj.startsWithEOL ) {
								data = '<br data-cke-eol="1">' + data;
							}
							if ( dataObj.endsWithEOL ) {
								data += '<br data-cke-eol="1">';
							}

							if ( type == 'auto' ) {
								type = ( trueType == 'html' || defaultType == 'html' ) ? 'html' : 'text';
							}

							dataObj.type = type;
							dataObj.dataValue = data;
							delete dataObj.preSniffing;
							delete dataObj.startsWithEOL;
							delete dataObj.endsWithEOL;
							
							
							
							
						/*	evt.data.dataValue = data;
							
							evt.data.dataValue = evt.data.dataValue
								.replace( /zooterkins/gi, 'z********s' )
								.replace( /gadzooks/gi, 'g******s' );*/
								
						}, null, null, 6 );				

					}
				} );	
				
				function filterContent( editor, data, filter ) {
					var fragment = CKEDITOR.htmlParser.fragment.fromHtml( data ),
						writer = new CKEDITOR.htmlParser.basicWriter();

					filter.applyTo( fragment, true, false, editor.activeEnterMode );
					fragment.writeHtml( writer );

					return writer.getHtml();
				}

				
				
				// Returns:
				// * 'htmlifiedtext' if content looks like transformed by browser from plain text.
				//		See clipboard/paste.html TCs for more info.
				// * 'html' if it is not 'htmlifiedtext'.
				function recogniseContentType( data ) {
					if ( CKEDITOR.env.webkit ) {
						// Plain text or ( <div><br></div> and text inside <div> ).
						if ( !data.match( /^[^<]*$/g ) && !data.match( /^(<div><br( ?\/)?><\/div>|<div>[^<]*<\/div>)*$/gi ) )
							return 'html';
					} else if ( CKEDITOR.env.ie ) {
						// Text and <br> or ( text and <br> in <p> - paragraphs can be separated by new \r\n ).
						if ( !data.match( /^([^<]|<br( ?\/)?>)*$/gi ) && !data.match( /^(<p>([^<]|<br( ?\/)?>)*<\/p>|(\r\n))*$/gi ) )
							return 'html';
					} else if ( CKEDITOR.env.gecko ) {
						// Text or <br>.
						if ( !data.match( /^([^<]|<br( ?\/)?>)*$/gi ) )
							return 'html';
					} else {
						return 'html';
					}

					return 'htmlifiedtext';
				}
				
				
				// This function transforms what browsers produce when
				// pasting plain text into editable element (see clipboard/paste.html TCs
				// for more info) into correct HTML (similar to that produced by text2Html).
				function htmlifiedTextHtmlification( config, data ) {
					function repeatParagraphs( repeats ) {
						// Repeat blocks floor((n+1)/2) times.
						// Even number of repeats - add <br> at the beginning of last <p>.
						return CKEDITOR.tools.repeat( '</p><p>', ~~( repeats / 2 ) ) + ( repeats % 2 == 1 ? '<br>' : '' );
					}

						// Replace adjacent white-spaces (EOLs too - Fx sometimes keeps them) with one space.
					data = data.replace( /\s+/g, ' ' )
						// Remove spaces from between tags.
						.replace( /> +</g, '><' )
						// Normalize XHTML syntax and upper cased <br> tags.
						.replace( /<br ?\/>/gi, '<br>' );

					// IE - lower cased tags.
					data = data.replace( /<\/?[A-Z]+>/g, function( match ) {
						return match.toLowerCase();
					} );

					// Don't touch single lines (no <br|p|div>) - nothing to do here.
					if ( data.match( /^[^<]$/ ) )
						return data;

					// Webkit.
					if ( CKEDITOR.env.webkit && data.indexOf( '<div>' ) > -1 ) {
							// One line break at the beginning - insert <br>
						data = data.replace( /^(<div>(<br>|)<\/div>)(?!$|(<div>(<br>|)<\/div>))/g, '<br>' )
							// Two or more - reduce number of new lines by one.
							.replace( /^(<div>(<br>|)<\/div>){2}(?!$)/g, '<div></div>' );

						// Two line breaks create one paragraph in Webkit.
						if ( data.match( /<div>(<br>|)<\/div>/ ) ) {
							data = '<p>' + data.replace( /(<div>(<br>|)<\/div>)+/g, function( match ) {
								return repeatParagraphs( match.split( '</div><div>' ).length + 1 );
							} ) + '</p>';
						}

						// One line break create br.
						data = data.replace( /<\/div><div>/g, '<br>' );

						// Remove remaining divs.
						data = data.replace( /<\/?div>/g, '' );
					}

					// Opera and Firefox and enterMode != BR.
					if ( CKEDITOR.env.gecko && config.enterMode != CKEDITOR.ENTER_BR ) {
						// Remove bogus <br> - Fx generates two <brs> for one line break.
						// For two line breaks it still produces two <brs>, but it's better to ignore this case than the first one.
						if ( CKEDITOR.env.gecko )
							data = data.replace( /^<br><br>$/, '<br>' );

						// This line satisfy edge case when for Opera we have two line breaks
						//data = data.replace( /)

						if ( data.indexOf( '<br><br>' ) > -1 ) {
							// Two line breaks create one paragraph, three - 2, four - 3, etc.
							data = '<p>' + data.replace( /(<br>){2,}/g, function( match ) {
								return repeatParagraphs( match.length / 4 );
							} ) + '</p>';
						}
					}

					return switchEnterMode( config, data );
				}
				
				
				function filtersFactoryFactory() {
					var filters = {};

					// GDocs generates many spans and divs, therefore `all` parameter is used
					// to create default filter in Webkit/Blink. (#13877)
					function setUpTags( all ) {
						var tags = {};

						for ( var tag in CKEDITOR.dtd ) {
							if ( tag.charAt( 0 ) != '$' && ( all || tag != 'div' && tag != 'span') ) {
								tags[ tag ] = 1;
							}
						}

						return tags;
					}

					// Checks if content is pasted from Google Docs.
					// Google Docs wraps everything in element with [id^=docs-internal-guid-],
					// so that function just checks if such element exists. (#13877)
					function isPastedFromGDocs( element ) {
						if ( element.attributes.id && element.attributes.id.match( /^docs\-internal\-guid\-/ ) ) {
							return true;
						} else if ( element.parent && element.parent.name ) {
							return isPastedFromGDocs( element.parent );
						}

						return false;
					}

					// Process data from Google Docs:
					// * turns `*[id^=docs-internal-guid-]` into `span`;
					// * turns `span(text-decoration=underline)` into `u`;
					// * turns `span(font-style=italic)` into `em`
					// * turns `span(font-style=italic)(text-decoration=underline)` into `u > em`. (#13877)
					// 
					function processDataFromGDocs( element ) {
						
						var styles = element.attributes.style && CKEDITOR.tools.parseCssText( element.attributes.style );
						
						if ( element.attributes.id && element.attributes.id.match( /^docs\-internal\-guid\-/ ) ) {
							return element.name = 'span';				
						}

						if ( !styles ) {
							return;
						}

						if ( styles[ 'font-style' ] == 'italic' && styles[ 'text-decoration' ] == 'underline' ) {
							element.name = 'em';
							element.wrapWith( new CKEDITOR.htmlParser.element( 'u' ) );		
							if (styles[ 'font-weight' ] > 400) {
								element.wrapWith( new CKEDITOR.htmlParser.element( 'strong' ) );	
							}					
						} else if ( styles[ 'text-decoration' ] == 'underline' ) {
							element.name = 'u';		
							if (styles[ 'font-weight' ] > 400) {
								element.wrapWith( new CKEDITOR.htmlParser.element( 'strong' ) );						
							}					
						} else if ( styles[ 'font-style' ] == 'italic' ) {
							element.name = 'em';	
							if (styles[ 'font-weight' ] > 400) {
								element.wrapWith( new CKEDITOR.htmlParser.element( 'strong' ) );						
							}				
						}
					}

					function createSemanticContentFilter() {
						var filter = new CKEDITOR.filter();

						filter.allow( {
							$1: {
								elements: setUpTags(),
								attributes: true,
								styles: false,
								classes: false
							}
						} );

						return filter;
					}

					function createWebkitDefaultFilter() {
						var filter = createSemanticContentFilter();

						// Preserves formatting while pasting from Google Docs in Webkit/Blink
						// with default paste filter. (#13877)
						filter.allow( {
							$2: {
								elements: setUpTags( true ),
								attributes: true,
								styles: true,
								match: function( element ) {
									return isPastedFromGDocs( element );
								}
							}
						} );

						filter.addElementCallback( processDataFromGDocs );

						return filter;
					}

					return {
						get: function( type ) {
							if ( type == 'plain-text' ) {
								// Does this look confusing to you? Did we forget about enter mode?
								// It is a trick that let's us creating one filter for edidtor, regardless of its
								// activeEnterMode (which as the name indicates can change during runtime).
								//
								// How does it work?
								// The active enter mode is passed to the filter.applyTo method.
								// The filter first marks all elements except <br> as disallowed and then tries to remove
								// them. However, it cannot remove e.g. a <p> element completely, because it's a basic structural element,
								// so it tries to replace it with an element created based on the active enter mode, eventually doing nothing.
								//
								// Now you can sleep well.
								return filters.plainText || ( filters.plainText = new CKEDITOR.filter( 'br' ) );
							} else if ( type == 'semantic-content' ) {
								return filters.semanticContent || ( filters.semanticContent = createSemanticContentFilter() );
							} else if ( type == 'webkit-default-filter' ) {
								// Webkit based browsers need semantic filter, because they produce terrible HTML without it.
								// However original `'semantic-content'` filer is too strict and prevents pasting styled contents
								// from many sources (e.g. Google Docs). Therefore that type extends original `'semantic-content'` filter. (#13877)
								return filters.webkitDefaultFilter || ( filters.webkitDefaultFilter = createWebkitDefaultFilter() );
							} else if ( type ) {
								// Create filter based on rules (string or object).
								return new CKEDITOR.filter( type );
							}

							return null;
						}
					};
				}
				
				
				function switchEnterMode( config, data ) {
					if ( config.enterMode == CKEDITOR.ENTER_BR ) {
						data = data.replace( /(<\/p><p>)+/g, function( match ) {
							return CKEDITOR.tools.repeat( '<br>', match.length / 7 * 2 );
						} ).replace( /<\/?p>/g, '' );
					} else if ( config.enterMode == CKEDITOR.ENTER_DIV ) {
						data = data.replace( /<(\/)?p>/g, '<$1div>' );
					}

					return data;
				}
				
				
			} )();

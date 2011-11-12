# INFRACTIONS

One of the rarely mentioned edge cases with the way in which RubyGems loads
library files, and in fact the way Ruby's load system works in general, is
that the _lib space_ is a free for all. Any library can drop any file into
their package's loadpath (i.e. the lib/ directory) and potentially clobber
a file of the same name in some one else's library.

Here's an example irb session that demonstrate the issue. Here I already added
a `matrix.rb` file, that does nothing but <code>puts "HERE!"</code>, to the `cuts`
gem and installed it.

    require 'rubygems'
    => true 
    gem "cuts"
    => true 
    require 'matrix'
    HERE!
    => true 

Now, a good <i>gem citizen</i> knows to put their scripts in a directory with
the same name as their gem package, nonetheless you might be surprised to see
how often this simple but important practice is violated.
Consequently the order in which such gems are searched becomes of
paramount importance --something that worked just fine on one machine can
suddenly stop working on another for no obvious reason.


## ISOLATIONISTS

It is also worth noting that the recent crop of gem isolation systems, such as
Bundler and Isolate, while serving to reduce the likelihood of possible name
clashes still do not fully remedy the issue. They merely reduce the number of
gems that could cause the problem for any given dependent application.


## SOLUTION

The Ruby and Gem wedges solves the issue entirely by allowing us to load files
from a single gem and only that gem. It does so by adding a new valid syntax
to Ruby's #load and #require methods. As an example, let's say we wanted to
load the troff.rb script from the unroller library.

  require 'troff', :from => 'unroller'

The colon is used to separate the gem name from the rest of the pathname.
With this we can be 100% certain that the troff.rb file was required
from the unroller gem and not a 'troff.rb' file from any other
gem that might have created a script by the same name.


## EXTENT OF THE ISSUE

You might be suprised to find out how many libraries violate the best practice
of putting all thier scripts in a subdirectory by the same name as the package.
Just on my development system alone, which really has but a small number of
gems installed, there are quite a few cases.

    ParseTree-2.2.0/lib/:

      composite_sexp_processor.rb
      parse_tree.rb
      sexp.rb
      sexp_processor.rb
      unified_ruby.rb
      unique.rb

    ParseTree-3.0.3/lib/:

      gauntlet_parsetree.rb
      parse_tree.rb
      parse_tree_extensions.rb
      unified_ruby.rb
      unique.rb

    RedCloth-4.1.9/lib/:

      case_sensitive_require
      redcloth
      redcloth.rb
      redcloth_scan.so

    RedCloth-4.2.2/lib/:

      case_sensitive_require
      redcloth
      redcloth.rb
      redcloth_scan.so
      tasks

    ZenTest-4.0.0/lib/:
      autotest
      autotest.rb
      focus.rb
      functional_test_matrix.rb
      multiruby.rb
      unit_diff.rb
      zentest.rb
      zentest_mapping.rb

    bossman-0.4.1/lib/:

      bossman
      bossman.rb
      extensions

    builder-2.1.2/lib/:

      blankslate.rb
      builder
      builder.rb

    chardet-0.9.0/lib/:

      Big5Freq.rb
      Big5Prober.rb
      CharDistributionAnalysis.rb
      CharSetGroupProber.rb
      CharSetProber.rb
      CodingStateMachine.rb
      ESCSM.rb
      EUCJPProber.rb
      EUCKRFreq.rb
      EUCKRProber.rb
      EUCTWFreq.rb
      EUCTWProber.rb
      EscCharSetProber.rb
      GB2312Freq.rb
      GB2312Prober.rb
      HebrewProber.rb
      JISFreq.rb
      JapaneseContextAnalysis.rb
      LangBulgarianModel.rb
      LangCyrillicModel.rb
      LangGreekModel.rb
      LangHebrewModel.rb
      LangHungarianModel.rb
      LangThaiModel.rb
      Latin1Prober.rb
      MBCSGroupProber.rb
      MBCSSM.rb
      MultiByteCharSetProber.rb
      SBCSGroupProber.rb
      SJISProber.rb
      SingleByteCharSetProber.rb
      UTF8Prober.rb
      UniversalDetector.rb

    eventmachine-0.12.10/lib/:

      em
      eventmachine.rb
      evma
      evma.rb
      fastfilereaderext.so
      jeventmachine.rb
      pr_eventmachine.rb
      rubyeventmachine.so

    hpricot-0.8.1/lib/:

      fast_xs.so
      hpricot
      hpricot.rb
      hpricot_scan.so

    html5-0.10.0/lib/:

      core_ext
      html5
      html5.rb

    http_router-0.2.5/lib/:

      ext
      http_router
      http_router.rb

    httpclient-2.1.5.2/lib/:

      http-access2
      http-access2.rb
      httpclient
      httpclient.rb
      tags

    linecache-0.43/lib/:

      linecache.rb
      trace_nums.so
      tracelines.rb

    liquid-2.0.0/lib/:

      extras
      liquid
      liquid.rb

    mail-2.2.5/lib/:

      VERSION
      mail
      mail.rb
      mail.rbc
      tasks

    maruku-0.5.9/lib/:

      maruku
      maruku.rb
      sort_prof.rb

    mechanize-0.9.3/lib/:

      mechanize.rb
      www

    memcache-client-1.7.8/lib/:

      continuum_native.rb
      memcache.rb
      memcache_util.rb

    mocha-0.9.8/lib/:

      mocha
      mocha.rb
      mocha_standalone.rb
      stubba.rb

    packr-3.1.0/lib/:

      packr
      packr.rb
      string.rb

    qed-2.3.0/lib/:

      qed
      qed.rb
      qedoc

    quality_extensions-1.1.6/lib/:

      Xfind_bug_test.rb
      quality_extensions
      quality_extensions.rb

    radiant-0.8.2/lib/:

      annotatable.rb
      autotest
      generators
      inheritable_class_attributes.rb
      local_time.rb
      login_system.rb
      method_observer.rb
      plugins
      radiant
      radiant.rb
      simpleton.rb
      task_support.rb
      tasks

    rails-2.3.5/lib/:

      code_statistics.rb
      commands
      commands.rb
      console_app.rb
      console_sandbox.rb
      console_with_helpers.rb
      dispatcher.rb
      fcgi_handler.rb
      initializer.rb
      performance_test_help.rb
      rails
      rails_generator
      rails_generator.rb
      railties_path.rb
      ruby_version_check.rb
      rubyprof_ext.rb
      source_annotation_extractor.rb
      tasks
      test_help.rb
      webrick_server.rb

    railties-3.0.0.beta/lib/:

      generators
      rails
      rails.rb

    ramaze-2010.01/lib/:

      proto
      ramaze
      ramaze.rb
      vendor

    rdiscount-1.3.5/lib/:

      markdown.rb
      rdiscount.rb
      rdiscount.so

    red-3.5.0/lib/:

      javascripts
      red
      red.rb

    red-4.1.7/lib/:

      red
      red.rb
      source

    rmagick-2.12.2/lib/:

      RMagick.rb
      RMagick2.so
      rvg

    ruby-prof-0.7.3/lib/:

      ruby-prof
      ruby-prof.rb
      ruby_prof.so
      unprof.rb

    ruby_parser-2.0.4/lib/:

      gauntlet_rubyparser.rb
      ruby_lexer.rb
      ruby_parser.rb
      ruby_parser.y
      ruby_parser_extras.rb

    rubygems-update-1.3.7/lib/:

      gauntlet_rubygems.rb
      rbconfig
      rubygems
      rubygems.rb
      ubygems.rb

    s3sync-1.2.5/lib/:

      HTTPStreaming.rb
      S3.rb
      S3_s3sync_mod.rb
      S3encoder.rb
      s3config.rb
      s3try.rb
      thread_generator.rb
      version.rb

    sexp_processor-3.0.1/lib/:

      composite_sexp_processor.rb
      sexp.rb
      sexp_processor.rb

    sexp_processor-3.0.3/lib/:

      composite_sexp_processor.rb
      sexp.rb
      sexp_processor.rb
      unique.rb

    slim_scrooge-1.0.5/lib/:

      callsite_hash.so
      slim_scrooge
      slim_scrooge.rb

    treetop-1.2.4/lib/:

      metagrammar.rb
      treetop
      treetop.rb

    unroller-1.0.0/lib/:

      troff.rb
      tron.rb
      unroller.rb

    xcb-0.0.1/lib/:

      directory_monitor.rb
      extreme_continuous_builder.rb
      notifiers.rb
      stacking_config.rb
      xcb_command.rb


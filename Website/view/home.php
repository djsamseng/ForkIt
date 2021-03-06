<?php require_once("view/header.php");?>
    <div class="container">

        <div class="row">
            <div class="box">
                <div class="col-lg-12 text-center">
                    <div id="carousel-example-generic" class="carousel slide">
                        <!-- Indicators -->
                        <ol class="carousel-indicators hidden-xs">
                            <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
                            <li data-target="#carousel-example-generic" data-slide-to="1"></li>
                        </ol>

                        <!-- Wrapper for slides -->
                        <div class="carousel-inner">
                            <div class="item active">
                                <img class="img-responsive img-full" src="view/img/download_slide.jpg" alt="">
                                <div style="position:absolute; bottom:50px; left:35%; width:70%; ">
                                    <h1 style="float:left;"><a href="?page=download">Download the App</a></h1>
                                    <img style="width:20%; margin-top:15px;" src="view/img/app_store.png" />
                                </div>
                            </div>
                            <div class="item">
                                <img class="img-responsive img-full" src="view/img/slide-1.jpg" alt="">
                                <div style="position:absolute; top:50px; left:5%; width:40%; ">
                                    <h1 style="float:left;">Need Help? Check out the <a href="?page=manual">Manual</a></h1>
                                </div>

                            </div>
                        </div>

                        <!-- Controls -->
                        <a class="left carousel-control" href="#carousel-example-generic" data-slide="prev">
                            <span class="icon-prev"></span>
                        </a>
                        <a class="right carousel-control" href="#carousel-example-generic" data-slide="next">
                            <span class="icon-next"></span>
                        </a>
                    </div>
                    <h2 class="brand-before">
                        <small>Welcome to</small>
                    </h2>
                    <h1 class="brand-name">Functional Flatware</h1>
                    <hr class="tagline-divider">
                    <h2>
                        <small>Identifying Food, 
                            <strong>Made Easy</strong>
                        </small>
                    </h2>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="box" style="min-height:300px">
                <div class="col-lg-12">
                    <hr>
                    <h2 class="intro-text text-center">Download the app
                        <strong>Today</strong>
                    </h2>
                    <hr>
                    <img class="img-responsive img-border img-left" src="view/img/download_small.jpg" alt="">
                    <hr class="visible-xs">
                    <p>Download the iPhone application on the Apple App Store.  Click <a href="?page=download">here</a> to view Functional Flatware in the Apple App Store.
                 </div>
            </div>
        </div>

        <div class="row">
            <div class="box">
                <div class="col-lg-12">
                    <hr>
                    <h2 class="intro-text text-center">Need help?
                        <strong>Check out our <a href="?page=manual">Manual</a></strong>
                    </h2>
                    <hr>
                </div>
            </div>
        </div>

    </div>
    <!-- /.container -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-lg-12 text-center">
                    <p>Copyright &copy; Functional Flatware 2014</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- jQuery -->
    <script src="view/js/jquery.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="view/js/bootstrap.min.js"></script>

    <!-- Script to Activate the Carousel -->
    <script>
    $('.carousel').carousel({
        interval: 7000 //changes the speed
    })
    </script>

</body>

</html>


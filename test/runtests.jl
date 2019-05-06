
using Test, WorldOceanAtlasTools

# Alias for short name
WOAT = WorldOceanAtlasTools

# For CI, make sure the download does not hang
ENV["DATADEPS_ALWAYS_ACCEPT"] = true

@testset "Downloading" begin
    years = [2013, 2018] # No NetCDF at these URLs for 2009 data
    vvs = ["p", "i", "n"]
    tts = collect(0:16)
    ggs = ["5°", "1°"]

    @testset " WOA$(WOAT.my_year(year))" for year in years
        @testset "Downloading $gg x $gg" for gg in ggs
            @testset " $(WOAT.my_averaging_period(tt))" for tt in tts[[1,2,13]]
                @testset " $(WOAT.WOA_path_varname(vv))" for vv in vvs
                    woa_lat, woa_lon, woa_μ_2D = WOAT.WOA_surface_map(year, vv, tt, gg)
                    @test woa_μ_2D isa Array{<:AbstractFloat, 2}
                    WOAT.WOA_remove(year, vv, tt, gg)
                end
            end
        end
    end
end
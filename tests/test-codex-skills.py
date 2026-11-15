from pathlib import Path
import runpy
import tempfile
import shutil

repo = Path(__file__).resolve().parent.parent
sync = runpy.run_path(str(repo / 'bootstrap/sync-codex-skills.py'))['sync']
render = runpy.run_path(str(repo / 'bootstrap/render-codex-skill.py'))['render']

def skill(source, name):
    folder=source/name
    folder.mkdir(parents=True)
    (folder/'SKILL.md').write_text(f'---\nname: {name}\ndescription: A workflow: for {name}.\nmodel: sonnet\n---\nRead ~/.claude/skills/{name}/references/context.md\n')
    (folder/'references').mkdir()
    (folder/'references/context.md').write_text('Supporting context')
    return folder

with tempfile.TemporaryDirectory() as temporary:
    root=Path(temporary); source=root/'source'; source.mkdir()
    target=root/'user/skills'; state=root/'state.json'
    skill(source,'first')
    (source/'first/references/.template').write_text('Hidden resource')
    excluded=skill(source,'session-status')
    assert sync(source,target,state,{'session-status'},render)==1
    assert not (target/'session-status').exists()
    assert 'model:' not in (target/'first/SKILL.md').read_text()
    assert '~/.agents/skills/first/' in (target/'first/SKILL.md').read_text()
    assert (target/'first/references/context.md').is_symlink()
    assert (target/'first/references/.template').read_text()=='Hidden resource'
    sentinel=target/'first/local.txt'; sentinel.write_text('local only')
    new=skill(source,'new-workflow')
    assert sync(source,target,state,{'session-status'},render)==2
    assert (target/'new-workflow/SKILL.md').exists()
    before=state.read_bytes(); sync(source,target,state,{'session-status'},render); assert state.read_bytes()==before
    shutil.rmtree(new)
    sync(source,target,state,{'session-status'},render)
    assert not (target/'new-workflow/SKILL.md').exists()
    assert sentinel.read_text()=='local only'
    managed=target/'first/SKILL.md'; managed.write_text('user modification')
    try: sync(source,target,state,{'session-status'},render)
    except ValueError: pass
    else: raise AssertionError('Overwrote a locally modified generated manifest')
    assert managed.read_text()=='user modification'
    managed.write_text(render('first',source))
    # Unknown destinations must be preserved, even for a new source skill.
    collision=skill(source,'collision'); (target/'collision').mkdir(); (target/'collision/SKILL.md').write_text('local skill')
    try: sync(source,target,state,{'session-status'},render)
    except ValueError: pass
    else: raise AssertionError('Overwrote local skill')
    assert (target/'collision/SKILL.md').read_text()=='local skill'
    shutil.rmtree(collision)
    # Unsupported execution semantics fail before any target is changed.
    unsupported=skill(source,'unsupported'); p=unsupported/'SKILL.md'; p.write_text(p.read_text().replace('model: sonnet','context: fork'))
    before=state.read_bytes()
    try: sync(source,target,state,{'session-status'},render)
    except ValueError: pass
    else: raise AssertionError('Unsupported execution field accepted')
    assert state.read_bytes()==before
    assert not (target/'unsupported').exists()
    shutil.rmtree(unsupported)
    invalid=skill(source,'invalid'); p=invalid/'SKILL.md'; p.write_text(p.read_text().replace('name: invalid','name: [broken'))
    try: sync(source,target,state,{'session-status'},render)
    except ValueError: pass
    else: raise AssertionError('Invalid manifest accepted')
    assert not (target/'invalid').exists()
    shutil.rmtree(invalid)
    # A symlinked destination ancestor must not redirect generated files.
    alternate=root/'elsewhere'; alternate.mkdir(); (target/'first/references/context.md').unlink(); (target/'first/references/.template').unlink(); (target/'first/references').rmdir(); (target/'first/references').symlink_to(alternate,target_is_directory=True)
    try: sync(source,target,state,{'session-status'},render)
    except ValueError: pass
    else: raise AssertionError('Accepted symlinked ancestor')
    assert not (alternate/'context.md').exists()
    # Initial migration may adopt identical pre-existing outputs and links.
    fresh=root/'migration/skills'; fresh.mkdir(parents=True); (fresh/'first').mkdir(); (fresh/'first/SKILL.md').write_text(render('first',source)); (fresh/'first/references').mkdir(); (fresh/'first/references/context.md').symlink_to(source/'first/references/context.md')
    assert sync(source,fresh,root/'migration-state.json',{'session-status'},render)==1
print('Passed: automatic discovery, additions, removal, resource links, idempotence, exclusions, local preservation, conflicts, unsupported fields, ancestor symlinks and migration.')
